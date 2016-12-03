#!/bin/bash

# @author Lauren, Matthieu, Benjamin

#Programme qui permet la création de backups
#Prends en paramètre le fichier de configuration qui permet au programme de savoir quels fichier sauvegarder

#######################################################################################################################################################
#                                                               Importation des scripts utilisés                                                      #
#######################################################################################################################################################
source SOURCES/chiffrement.sh
source SOURCES/compression.sh

#######################################################################################################################################################
#                                            Fonction qui crée, chiffre et compresse un dossier de backup                                             #
#######################################################################################################################################################
function backup(){
	if [ ! -d "$2" ]; then
		#créer le dossier $2 si il n'existe pas
		mkdir "$2"
	fi
	DIR=$2/`date +%s`
	#créer un dossier de backup à la date (timestamp) actuel
	mkdir $DIR
	#copier les fichiers dans le dossier
	cat "$1" | xargs -I{} cp {} $DIR
	#chiffrement du dossier
	chiffrement "$DIR"
	DIR=${DIR}.gpg
	#compression du dossier et suppression du dossier non compressé
	compression "$DIR"
	rm -d $DIR
}
