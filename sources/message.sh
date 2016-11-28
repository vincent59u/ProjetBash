#!/bin/bash

#Programme permettant l'affichage d'un message placé en paramètre
#$1 correspond au titre de la boite de dialogue
#$2 correspond au corps du message

function affiche_message(){
	DIALOG=${DIALOG=dialog}

	#Personnalisation de la fenêtre
	$DIALOG --title "$1" \
		--msgbox "$2" 10 30

	#Switch sur le choix de l'utilisateur
	case $? in
	        0)      #Relance le main pour que l'utilisateur continu la navigation dans l'application
			bash main.sh;;
       	 	255)    echo "Appuyé sur Echap. ";;
	esac
}
