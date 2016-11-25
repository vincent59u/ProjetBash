#!/bin/bash

#Création de la boite de dialog
DIALOG=${DIALOG=dialog}

#Personnalisation de la fenêtre
$DIALOG --title "Succès!" --clear \
	--msgbox "$1" 10 30

#Switch sur l'option choisi par l'utilisateur
case $? in
	0)	exit;;
	255)	echo "Appuyé sur Echap. ";;
esac
