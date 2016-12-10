#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Programme de récupération de synopsis.
#Il permet de récupérer les synopsys de la série télévisée Games of Thrones

#######################################################################################################################################################
#								Fonction de récupération de synopsis						      #
#######################################################################################################################################################
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
	FILE=$(curl -O https://daenerys.xplod.fr/synopsis.php)
	#Pour chaque synopsis
	for titre in $(cat synopsis.php); do
	        if [[ "$titre" =~ $regex ]]; then
			#On affiche le nom de l'épisode
	                echo "S"${BASH_REMATCH[1]}"E"${BASH_REMATCH[2]}":"${BASH_REMATCH[3]}
			#On récupère la page de la synopsis avec Curl
			`curl -o "$HOME/GoT/Saison "${BASH_REMATCH[1]}" Episode  "${BASH_REMATCH[2]}".txt" https://daenerys.xplod.fr/synopsis.php?s=${BASH_REMATCH[1]}"&"e=${BASH_REMATCH[2]} | grep -oEi "$regex2"`
			#On ne récupère que ce qui match la regex dans la variable valtemp
			valtemp=`cat "$HOME/GoT/Saison "${BASH_REMATCH[1]}" Episode  "${BASH_REMATCH[2]}".txt" | grep -oEi $regex2`
			#On echo ensuite le texte sans les balises
			`echo $valtemp | grep -oE "[A-Z]{1}([a-zA-Z,.;']+ {0,1})+">"$HOME/GoT/Saison "${BASH_REMATCH[1]}" Episode  "${BASH_REMATCH[2]}".txt"`
			#Enfin on ajoute le lien vers le fichier supersynopsis
			`echo "https://daenerys.xplod.fr/supsyn.php?e="${BASH_REMATCH[2]}"&s="${BASH_REMATCH[1]}>> "$HOME/GoT/Saison "${BASH_REMATCH[1]}" Episode  "${BASH_REMATCH[2]}".txt"`
			#On crée le fichier supersynopsis dans le dossier GoT
			#`curl -o "$HOME/GoT/synopsis_"${BASH_REMATCH[1]}"_"${BASH_REMATCH[2]}".syn.gpg" https://daenerys.xplod.fr/supsyn.php?e=${BASH_REMATCH[2]}"&"s=${BASH_REMATCH[1]}`
	        fi
	done
	#On supprime le fichier permettant d'afficher le nom des épisodes
	rm synopsis.php
}
