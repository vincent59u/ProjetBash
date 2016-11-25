#!/bin/bash

# $i -> --conf backup.conf
# $j -> --backupdir /var/backups

function backup(){
	if [ ! -d "$2" ]; then 
		mkdir "$2" #créer le dossier $2 si il n'existe pas
	fi 
	cat "$1" | xargs -I{} cp {} $2 #attention, fichier .conf copié dans le nouveau dossier
}

if [ -z "$*" ]; then #si aucun paramètre : noms par défault
	backup backup.conf /var/backups
else #sinon on récupère les noms du fichier et du dossier
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
fi

#Commentaires : chercher les possibles bugs


