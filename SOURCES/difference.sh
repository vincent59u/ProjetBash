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
	regex="^([>|<]{1})[ ]*([a-zA-Z0-9]+(\.[a-zA-Z]+)*)$"
	#On récupère la différence entre les deux backups placé en paramètre.
	diff <(tar --show-transformed-names --strip-components=1 -tf $1 | sort) <(tar --show-transformed-names --strip-components=1 -tf $2 | sort) > tmp.txt
	#on récupère dans une variable le résultat de la commande ci-dessus.
	resultat=`cat tmp.txt`
	#Si la variable est vide, cela veut dire qu il y a aucune différence entre les deux backups.
	if [ -z $resultat ]; then
		echo "Il n'y a aucune différence entre ces deux backups"
	else
		#On boucle sur chaque ligne du fichier tmp.txt
		for ligne in $resultat; do
			if [[ "$ligne" =~ $regex ]]; then
				if [ ${BASH_REMATCH[1]} = "<" ]; then
					echo "Le fichier ou dossier ${BASH_REMATCH[2]} a été ajouté entre les deux backups."
				fi

				if [ ${BASH_REMATCH[1]} = ">" ]; then
                                        echo "Le fichier ou dossier ${BASH_REMATCH[2]} a été supprimé entre les deux backups."
                                fi
			fi
		done
	fi
	#On supprime le fichier temporaire
	rm tmp.txt
}
