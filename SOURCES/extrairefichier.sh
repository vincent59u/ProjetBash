#!/bin/bash
source GUI/fenetre.sh
#On spécifie le nom de l'archive et du fichier à extraire
affiche_selectionFichier "Veuillez selectionner l'archive" "/var/backups"
if [ $? -eq 0 ]; then
#On récupère le chemin du dossier
dossier=$(echo "$fichier" | grep -oEi "[0-9]*")
#Choix du fichier à saisir
affiche_saisie "Choisir fichier à extraire de $fichier" "Fichier"
fich=$saisie
#Si l'utilisateur a bien appuyé sur Accepter et non Annuler
if [ $? -eq 0 ]; then
	#On choisit la destination ( pour éviter qu'il ecrase un fichier existant )
	affiche_saisie "Choisir chemin pour votre fichier" "Chemin"
	#S'il a choisit Accepter
		if [ $? -eq 0 ]; then
			destination=($saisie)
			#On decompresse le fichier choisi de l'archive choisi dans la destination choisi ( Beaucoup de choisi n est pas ? )
			`tar xfvz $fichier $dossier"/"$fich.gpg -C $destination`
		fi
	fi
fi
