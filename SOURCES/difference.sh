#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Ce programme permet de faire la différence entre deux backups. Il indique les fichiers ajouter et/ou supprimé entre deux backups.

#######################################################################################################################################################
#						      Fonctions qui permet de faire la différence de backups					      #
#######################################################################################################################################################
#Fonction qui compare deux backups. $1 correspond au premier backup à comparer. $2 correspond au deuxième backup à comparer.
function difference(){
	#Modification de la variable IFS afin d'itérer sur chaque ligne du fichier temporaire.
	IFS=$'\n'
	#Regex qui permet de voir si un fichier est ajouté ou supprimé entre deux backups.
	regex="^([>|<]{1})[ ]*(.+(\.[a-zA-Z]+)*)$"
	#On récupère la différence entre les deux backups placé en paramètre.
	diff <(tar --show-transformed-names --strip-components=1 -tf $1 | sort) <(tar --show-transformed-names --strip-components=1 -tf $2 | sort) > tmp.txt
	#on récupère dans une variable le résultat de la commande ci-dessus.
	resultat=`cat tmp.txt`
	#Si la variable est vide, cela veut dire qu il y a aucune différence entre les deux backups.
	if [ -z "$resultat" ]; then
		#On indique à l'utilisateur que les deux backups sont identiques (aucunes différences).
		affiche_message "Aucune différences" "Les deux backups que vous avez entrez en paramètre ne contienne aucune différences. Ils sont donc identiques."
	else
		#Déclaration de deux tableau qui permettent de stocker la liste des fichiers ajoutés et/ou supprimés entre ces deux backups
		tabSuppr=()
		tabAjout=()
		#On boucle sur chaque ligne du fichier tmp.txt
		for ligne in $(cat tmp.txt); do
			#Si la ligne match avec la regex, cela veut dire quil y a un fichier qui a été supprimé ou ajouté.
			if [[ "$ligne" =~ $regex ]]; then
				#Si le fichier a été supprimé entre les deux backups, on l'indique à l utilisateur.
				if [ ${BASH_REMATCH[1]} = "<" ]; then
					#On ajoute le fichier dans le tableau de valeur
					tabSuppr=("${tabSuppr[@]}" "${BASH_REMATCH[2]}")
				fi
				#Si le fichier a été ajouté entre les deux backups, on l'indique à l utilisateur.
				if [ ${BASH_REMATCH[1]} = ">" ]; then
					#On ajoute le fichier dans le tableau de valeur
                                        tabAjout=("${tabAjout[@]}" "${BASH_REMATCH[2]}")
                                fi
			fi
		done
		#On crée une boite de dialog pour afficher l'ensemble des différences entre les deux backups.
		affiche_message "Liste des différences" "Voici la liste des fichiers qui ont été supprimés et/ou ajoutés entre les deux backups que vous avez sélectionné.\n\nFichier(s) supprimé(s) :\n${tabSuppr[*]}\n\nFichier(s) ajouté(s) :\n${tabAjout[*]}"
	fi
	#On supprime le fichier temporaire
	rm tmp.txt
}
