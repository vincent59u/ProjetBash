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
        affiche_saisie "Saisir un nom de dossier" "Veulliez saisir le nom de dossier de votre backup. (Laissez vide pour /var/backups)"
        retour=$?
		#Si l'utilisateur a appuyé sur annuler, on quitte la fonction de backup
		if [ $retour -eq 1 ]; then
			affiche_message "Annulation" "L'opération a bien été annulée"
		else
			#Si le nom est vide, le dossier est /var/backups
        	if [[ -z "$saisie" ]]; then
            	saisie="/var/backups"
       		else		    
				#On crée le dossier qui contiendra le dossier de backups compressé, si ce dossier n'existe pas déjà
				if [ ! -d "$saisie" ]; then 
					mkdir $saisie
				fi
			fi			
			#On créé le dossier de backup, qui contiendra les fichiers à sauvegarder et sera ensuite compressé
			DIR=$saisie/`date +%s`
			mkdir $DIR
			#On copie le dossier de backup l ensembles des fichier ou dossier indiqué dans le fichier de configuration
			for ligne in $(cat $1); do
				#Chiffrement de chaque fichiers avant de le copier dans le dossier de backup
				chiffrement $ligne
				#On déplace le fichier crypté dans le dossier de backup
				mv ${ligne}.gpg $DIR
			done
			    #compression du dossier de backup. Une fois le dossier compressé, la version non-compressé sera supprimée par le programme.
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
