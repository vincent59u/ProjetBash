#!/bin/bash

#Programme permettant l'affichage d'un message placé en paramètre
DIALOG=${DIALOG=dialog}

#Personnalisation de la fenêtre
$DIALOG --title "Annulation" \
	--msgbox "$1" 10 30

#Switch sur le choix de l'utilisateur
case $? in
        0)      #Relance le main pour que l'utilisateur continu la navigation dans l'application
		bash main.sh;;
        255)    echo "Appuyé sur Echap. ";;
esac
