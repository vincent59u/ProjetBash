#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Programme de récupération de synopsis.
#Il permet de récupérer les synopsys de la série télévisée Games of Thrones

#######################################################################################################################################################
#                                                               Importation des scripts utilisés                                                      #
#######################################################################################################################################################
source SOURCES/email.sh

#######################################################################################################################################################
#								Fonction de récupération de synopsis						      #
#######################################################################################################################################################

#//TODO : si le script fonctionne en silencieux, les notifications doivent être envoyées par mail (récupèrer le mail dans la clé publique ?)

#Fonction de récupération de synopsis sur un serveur distant
function recupererSynopsis(){
	#Si l'utilisateur n a pas de dossier GoT on en crée un
	if [ ! -d "$HOME/GoT" ]; then
		mkdir "$HOME/GoT"
	fi
	#IFS permet de changer le séparateur pour ne prendre en compte que les retour à la ligne et #pas les espaces
	IFS=$'\n'
	#La première regex sert à récupérer le fichier de tous les synopsis afin de boucler sur tous les détails de synopsis
	regex="<a href=\"synopsis\.php\?s=([0-9]{1,2})\&amp;e=[0-9]{1,2}\">Episode ([0-9]{1,2}): (([A-Za-z,]+ {0,1})+)<\/a>"
	#La seconde regex récupère le contenu de la balise avec le texte de la synopsis
	regex2="<p class=\"left-align light\">([a-zA-Z,.;']+ {0,1})+<\/p>"
	curl -O https://daenerys.xplod.fr/synopsis.php >&- 2>&-
	connexionError $?
	#On va récupèrer chaque SuperSynopsis, et récupérer les synopsis valides
	#On récupère la clé publique disponible sur le site
	curl https://daenerys.xplod.fr/supersynopsis_signature.pub ​> public.key >&- 2>&- 
	#On importe la clé récupérée dans notre trousseau
	gpg --import public.key >&- 2>&-
	#On supprime ensuite le fichier temporaire
	rm public.key
	#On récupère le chemin des fichiers à vérifier
	#On récupère le nombre d'opérations à faire afin de pouvoir afficher une jolie barre de progression	(wc -l ne récupère pas le bon nombre)	
	nbr=`n=0 && for i in $(cat synopsis.php); do let n+=1; done && echo $n`
	#Pour chaque synopsis
	(
	n=1
	for titre in $(cat synopsis.php); do
	        if [[ "$titre" =~ $regex ]]; then
				#On crée le fichier supersynopsis dans le dossier GoT
				`curl -o "$HOME/GoT/synopsis_"${BASH_REMATCH[1]}"_"${BASH_REMATCH[2]}".syn.gpg" https://daenerys.xplod.fr/supsyn.php?e=${BASH_REMATCH[2]}"&"s=${BASH_REMATCH[1]} >&- 2>&-`
				connexionError $?
				FILE="$HOME/GoT/synopsis_"${BASH_REMATCH[1]}"_"${BASH_REMATCH[2]}".syn.gpg"
				#si le fichier de synopsis est bien valide :
				if `checkFile $FILE`; then
					#On récupère la page de la synopsis avec Curl
					`curl -o "$HOME/GoT/Saison "${BASH_REMATCH[1]}" Episode  "${BASH_REMATCH[2]}".txt" https://daenerys.xplod.fr/synopsis.php?s=${BASH_REMATCH[1]}"&"e=${BASH_REMATCH[2]} >&- 2>&- | grep -oEi "$regex2"`
					connexionError $?
					#On ne récupère que ce qui match la regex dans la variable valtemp
					valtemp=`cat "$HOME/GoT/Saison "${BASH_REMATCH[1]}" Episode  "${BASH_REMATCH[2]}".txt" | grep -oEi $regex2`
					#On echo ensuite le texte sans les balises
					`echo $valtemp | grep -oE "[A-Z]{1}([a-zA-Z,.;']+ {0,1})+">"$HOME/GoT/Saison "${BASH_REMATCH[1]}" Episode  "${BASH_REMATCH[2]}".txt"`
					#Enfin on ajoute le lien vers le fichier supersynopsis
					`echo "https://daenerys.xplod.fr/supsyn.php?e="${BASH_REMATCH[2]}"&s="${BASH_REMATCH[1]}>> "$HOME/GoT/Saison "${BASH_REMATCH[1]}" Episode  "${BASH_REMATCH[2]}".txt"`
				#si le fichier de synopsis est invalide :
				else
					#on envoi un email pour en informer l'utilisateur
					verificationError synopsis_"${BASH_REMATCH[1]}"_"${BASH_REMATCH[2]}"			
				fi
			#On supprime le fichier SuperSynopsis
			rm $FILE
	        fi
	#Code pour la jauge de progression sur la boite de dialogue
	echo "XXX"
	echo "Opération $(($n*100/$nbr))/100..." 
	echo "XXX"
	echo $(($n*100/$nbr))
	let n+=1
	done
	) | dialog --title 'Récupération des synopsis' --gauge 'Veuillez patienter' 0 0 0
	#On supprime le fichier permettant d'afficher le nom des épisodes
	rm synopsis.php
}

#Fonction permettant de vérifier si un fichier de synopsis passé en paramètre est correct ; pour se faire, on vérifie sa signature
checkFile(){
	gpg --verify "$1" >&- 2>&-
	#Code de sortie : 0 -> ok, >0 -> pas ok
	RESULT=$?
	if [[ "$RESULT" -eq 0 ]]; then
		return 0
	else
		return 1
	fi
}

