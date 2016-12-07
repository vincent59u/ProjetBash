#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Fichier qui contiendra l ensembles des fonction qui ont pour but d afficher une boite de dialogue à l utilisateur
#Chaque fonction correspondra à une fenêtre de dialogue particulière.

######################################################################################################################################################
#							Création de la fenêtre de dialogue							     #
######################################################################################################################################################
DIALOG=${DIALOG=dialog}

######################################################################################################################################################
#				Fonction qui affiche la fenêtre de dialogue qui permet la sélection de fichier   				     #
######################################################################################################################################################
#Cette fonction prends deux paramètres qui sont le titre de la fenêtre et le fichier de départ
function affiche_selectionFichier(){
        fichier=`$DIALOG --stdout --title "$1" --fselect "$2"/ 14 48`
}

######################################################################################################################################################
#                       		Fonction qui affiche une fenêtre d'information (Ok comme seule choix)  		                             #
######################################################################################################################################################
#Cette fonction permet d afficher un message à l utilisateur. $1 correspond au titre et $2 correspond au corps du message
function affiche_message(){
	DIALOG=${DIALOG=dialog}

        #Personnalisation de la fenêtre
        $DIALOG --title "$1" \
                --msgbox "$2" 10 30

	#Switch sur le choix de l'utilisateur
	case $? in
	        0)      #Relance le main pour que l utilisateur continu la navigation dans l application
			bash main.sh;;
       	 	255)    echo "Appuyé sur Echap. ";;
	esac
}

######################################################################################################################################################
#                                       Fonction qui affiche une fenêtre qui permet la saisie d'informations                                         #
######################################################################################################################################################
#Cette fonction permet d'afficher une fenêtre de saisie de texte. $1 correspond au titre et $2 correspond a l indication donné à l utilisateur
function affiche_saisie(){
	saisie=`$DIALOG --stdout --title "$1" --clear --inputbox "$2" 16 51`
}
