#!/bin/bash
#On spécifie le nom de l'archive et du fichier à extraire
temp= dialog --stdout --backtitle "Fichier a extraire du backup" --form "Entrez le nom de l'archive et du fichier" 0 0 0 "Archive: " 1 1 "/var/backups" 1 16 16 15 "Fichier: " 2 1 "" 2 16 16 15
#Si l'utilisateur a bien appuyé sur Accepter et non Annuler
if [ $? -eq 0 ]; then
	fichieretarchive=($temp)
	echo ${fichieretarchive[1]} > test.txt
	#if [[ ${fichieretarchive[0]}!=" " && ${fichieretarchive[1]}!=" " ]]; then
	#On choisit la destination ( pour éviter qu'il ecrase un fichier existant )
	dest=$(dialog --stdout --title "Destination du fichier" --inputbox "Entrez la destination du fichier" 20 20)
	#S'il a choisit Accepter
		if [ $? -eq 0 ]; then
			destination=($dest)
			#On decompresse le fichier choisi de l'archive choisi dans la destination choisi ( Beaucoup de choisi n est pas ? )
			`tar xfvz ${fichieretarchive[0]} $destination${fichieretarchive[1]}`
		fi
	#fi
fi
