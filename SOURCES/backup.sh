#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Programme qui permet la création de backups
#Prends en paramètre le fichier de configuration qui permet au programme de savoir quels fichier sauvegarder

#######################################################################################################################################################
#                                                               Importation des scripts utilisés                                                      #
#######################################################################################################################################################
source SOURCES/chiffrement.sh
source SOURCES/compression.sh
source SOURCES/supprimerAnciensBackups.sh
source SOURCES/synopsis.sh
source GUI/fenetre.sh

#######################################################################################################################################################
#                                       Fonction récursive qui permet de chiffrer chaque fichier et dossier d'un backup                               #
#######################################################################################################################################################
#Fonction récursive chiffrant un fichier ($1) et le déplacant dans le dossier précisé ($2)
function chiffMv(){
	#si le chemin correspond à un dossier;
	if [[ -d $1 ]]; then
		#on créé ce sous-dossier dans le dossier précisé
		mkdir $2/${1##*/}
		#on chiffre et déplace chaqun de ses fichiers
		for FILE in $1/*; do
			chiffMv $FILE $2/${1##*/}
		done
	#sinon, le chemin correspond à un fichier :
	else
		#Chiffrement de chaque fichier avant de le copier dans le dossier de backup
		chiffrement "$1"
		#Si le fichier n'a pas été chiffré, on ne le déplace pas (car il existe pas)
		if [ $retour -eq 0 ]; then
			#On déplace le fichier crypté dans le dossier de backup
			mv ${1}.gpg $2
		fi
	fi
}

#######################################################################################################################################################
#                                            Fonction qui crée, chiffre et compresse un dossier de backup                                             #
#######################################################################################################################################################
#Fonction qui permet la création de backup. $1 correspond au fichier de configuration placé en paramètre par l utilisateur.
function backup(){
	chemin=$PWD
	#Tout d'abord, on récupère les synopsis via daenerys.xplod.fr
	#Afin de gérer les erreurs de connexion, on teste le ping sur le site :
	if ping -qc 1 daenerys.xplod.fr >&- 2>&-; then 
		recupererSynopsis
	else 
		#si il n'y a pas de connexion, alors on ne récupère pas les synopsis
		affiche_message_info "Erreur de connexion" "Impossible d'accèder à daenerys.xplod.fr ; Votre backup va être effectué mais les synopsis ne seront pas mis à jour."
	fi
	#Appel d'une fonction qui permet à l utilisateur de saisir un nom de dossier dans une boite de dialogue
    	affiche_saisie_backup "Saisir un nom de dossier" "Veulliez saisir le nom de dossier de votre backup. (Laissez vide pour /var/backups)"
	#Si l'utilisateur à appuyer sur annuler ou echap.
	if [ $retour -eq 1 -o $retour -eq 255 ]; then
		affiche_message "Annulation" "L'opération a bien été annulée."
	else
		#Si le dossier saisi n'est pas créer, on le crée
		if [ ! -d "$saisie" ]; then
			mkdir $saisie
		fi
		#On créé le dossier de backup, qui contiendra les fichiers à sauvegarder et sera ensuite compressé
		DIR=$saisie/`date +%s`
		mkdir $DIR
		#On copie le dossier de backup : l'ensemble des fichier ou dossier indiqué dans le fichier de configuration
		for ligne in $(cat $1); do
			chiffMv $ligne $DIR
		done
		if [ $retour -eq 0 ]; then
			#compression du dossier de backup. Une fois le dossier compressé, la version non-compressé sera supprimée par le programme.
			compression "$DIR"
			#On regarde si le nombre de backups est supérieur à 100. On supprime le plus ancien backup le cas échéant
			supprimerAnciensBackups "$saisie"
			cd "$chemin"
			#On indique à l'utilisateur si l opération s est bien déroulée ou non
			if [ $retour -eq 0 ]; then
				affiche_message "Succès" "Le fichier de backup a été correctement créé."
			else
				affiche_message "Erreur..." "Une erreur est survenue lors de la création du dossier de backup, veuillez recommencer l'opération."
			fi
		fi
	fi
}
