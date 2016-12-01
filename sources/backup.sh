#!/bin/bash

#importation des scripts utilisés
source sources/chiffrement.sh
source sources/compression.sh

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

function AVirer(){
### bash backup.sh --conf backup.conf --backupdir /var/backups ###

#on récupère les noms du fichier et du dossier de backup ; si ils n'existent pas on utilise ceux par défault
NOM="backup.conf"
DIR="/var/backups"

for i in $(seq 1 $#); do
	j=$((i+1))
	if [ "${!i}" == "--conf" ]; then
		NOM=${!j}
	elif [ "${!i}" == "--backupdir" ]; then
		DIR=${!j}
	fi
done

backup $NOM $DIR
}
