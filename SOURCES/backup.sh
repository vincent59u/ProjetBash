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
source GUI/fenetre.sh

#######################################################################################################################################################
#                                            Fonction qui crée, chiffre et compresse un dossier de backup                                             #
#######################################################################################################################################################
function backup(){
	#Appel d'une fonction qui permet à l utilisateur de saisir un nom de dossier dans une boite de dialogue
        affiche_saisie "Saisir un nom de dossier" "Veulliez saisir le nom de dossier de votre backup."
        #On teste que l'utilisateur à bien entré un nom de dossier et non un espace, une tabulation ou un retour à la ligne
        retour=$?
        while [[ -z "$saisie" && ! "$retour" -eq 1 ]]; do
                affiche_saisie "Veuillez réessayer" "Entrez un nom de dossier de backup valide, c'est à dire avec des lettre et/ou des chiffres."
                retour=$?
        done
        #Si l'utilisateur a appuyé sur annuler, on quitte la fonction de backup
        if [ $retour -eq 1 ]; then
                affiche_message "Annulation" "L'opération a bien été annulée"
        else
		#On crée le dossier qui contiendra les fichiers et les dossiers sauvegarder. Tous les backups auront un nom du même type (Backup + timestamp)
		DIR=/var/backups/Backup_`date +%s`_"$saisie"
		#créer un dossier de backup dans le répertoire /var/backup
		mkdir $DIR
		#On copie le dossier de backup l ensembles des fichier ou dossier indiqué dans le fichier de configuration
		for ligne in $(cat $1); do
			#Chiffrement de chaque fichiers avant de le copier dans le dossier de backup
			chiffrement $ligne
			#On déplace le fichier crypté dans le dossier de backup
			mv ${ligne}.gpg $DIR
		done
	        #compression du dossier de backup. Une fois le dossier compressé, la version non-compressé sera supprimer par le programme.
	        compression "$DIR"
	        #On regarde si le nombre de backups est supérieur à 100. On supprime le plus ancien backup le cas échéant
	        supprimerAnciensBackups
	        #On indique à l'utilisateur si l opération s est bien déroulée ou non
	        if [ $? -eq 0 ]; then
	                affiche_message "Succès" "Le dossier de backup a été correctement fait."
	        else
	                affiche_message "Erreur..." "Une erreur est survenue lors de la création du dossier de backup, veuillez recommancer l'opération."
	        fi
	fi
}
