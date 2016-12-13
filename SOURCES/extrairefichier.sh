#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Ce programme permet d extraire un fichier d une archive de backup.

#######################################################################################################################################################
#                                                               Importation des scripts utilisés                                                      #
#######################################################################################################################################################
source GUI/fenetre.sh

#######################################################################################################################################################
#                                                               Fonction d'extraction de fichier                                                      #
#######################################################################################################################################################
#Fonction qui permet d'extraire un fichier d une archive
function extraireFichier(){
	#On demande à l'utilisateur de choisir le dossier qui contient le fichier à extraire. Par défaut les backups se trouve dans le dossier /var/backups
	affiche_selectionFichier "Veuillez selectionner un dossier contenant un backup" "/var/backups"
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
                                tar xfvz $fichier -C $destination $dossier"/"$fich.gpg >&- 2>&- 
				#On se déplace ver le dossier
				cd $destination"/"$dossier
				#On decrypte le fichier
				gpg --output $fich --decrypt -q $fich.gpg 
				#On le deplace dans le destination afin de pouvoir supprimer le dossier parent 
				mv $fich ../$fich 2>/dev/null
				#rm -I $dossier
			fi
		fi
	fi
}

extraireFichier
