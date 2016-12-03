#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Fichier qui contiendra l ensembles des fonction qui ont pour but d afficher une boite de dialogue à l utilisateur
#Chaque fonction correspondra à une fenêtre de dialogue particulière.

######################################################################################################################################################
#							Création de la fenêtre de dialogue							     #
######################################################################################################################################################
DIALOG=${DIALOG=dialog}

######################################################################################################################################################
#			Fonction qui affiche la fenêtre de dialogue qui permet la sélection du fichier de configuration				     #
######################################################################################################################################################

function affiche_selectionFichier(){
        selection=`$DIALOG --stdout --title "Choisissez le fichier de configuration" --fselect $HOME/ 14 48`
}

######################################################################################################################################################
#                       		Fonction qui affiche une fenêtre d'information (Ok comme seule choix)  		                             #
######################################################################################################################################################

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

