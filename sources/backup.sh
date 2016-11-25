#!/bin/bash

# $i -> --conf backup.conf
# $j -> --backupdir /var/backups

function backup(){
	mkdir "$2" #vérifier si le dossier existe avant de le créer
	cat "$1" | xargs -I{} cp {} $2 #attention, fichier .conf copié dans le nouveau dossier
}

if [ -z "$*" ]; then
	backup backup.conf /var/backups
else
	for i in "$@"; do #changer en séquence
		if [ "$i" == "--conf" ]; then
			NOM = $(i+1)
		elif [ "$i" == "--backupdir" ]; then
			DIR = $(i+1)	
		fi
	done
	backup $NOM $DIR #créer variables nom et dir pour quand il n'y a rien
fi

#Commentaires : fonction non optimisée contre les bugs ( on peut mettre plusieurs fois ---conf, ce qui changera le nom etc. )


