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
                --msgbox "$2" 20 45

	#Switch sur le choix de l'utilisateur
	case $? in
	        0)      #Relance le main pour que l utilisateur continu la navigation dans l application
			bash main.sh;;
       	 	255)    echo "Appuyé sur Echap. ";;
	esac
}

######################################################################################################################################################
#                                       Fonction qui affiche une fenêtre d'information (Ok comme seule choix)                                        #
######################################################################################################################################################
#Cette fonction permet d afficher un message à l utilisateur sans le ramener sur le main.sh. $1 correspond au titre et $2 correspond au corps du message
function affiche_message_info(){
        DIALOG=${DIALOG=dialog}

        #Personnalisation de la fenêtre
        $DIALOG --title "$1" \
                --msgbox "$2" 50 80
}


######################################################################################################################################################
#                                       Fonction qui affiche une fenêtre qui permet la saisie d'informations                                         #
######################################################################################################################################################
#Cette fonction permet d'afficher une fenêtre de saisie de texte. $1 correspond au titre et $2 correspond a l indication donné à l utilisateur
function affiche_saisie(){
	saisie=`$DIALOG --stdout --title "$1" --clear --inputbox "$2" 16 51`
	retour=$?
	#On boucle tant que l'utilisateur ne saisi pas son nom
        while [[ -z "$saisie" && ! "$retour" -eq 1 ]]; do
        	affiche_saisie "$1" "$2"
                retour=$?
        done
        #Si l'utilisateur a appuyé sur annuler, on quitte la fonction de backup
        if [ $retour -eq 1 ]; then
    	    affiche_message "Annulation" "L'opération a bien été annulée"
        fi
}

######################################################################################################################################################
#                                       Fonction qui affiche une fenêtre qui permet la saisie de mail                                                #
######################################################################################################################################################
#Cette fonction permet d'afficher une fenêtre de saisie de mail. $1 correspond au titre et $2 correspond a l indication donné à l utilisateur
function affiche_saisie_mail(){
	regex="^([A-Za-z0-9]+([._-]{0,1}[A-Za-z0-9]+)*)+@([A-Za-z0-9.-]+\.[A-Za-z]{2,6})$"
        saisie=`$DIALOG --stdout --title "$1" --clear --inputbox "$2" 16 51`
        retour=$?
	#On boucle tant que l'utilisateur ne saisi pas son mail
	while [[ -z "$saisie" || ! "$saisie" =~ $regex ]] && [[ ! $retour -eq 1 ]]; do
		affiche_saisie_mail "Veuillez recommencer" "Vous n'avez soit, pas écrit d'adresse mail, soit l'adresse mail entrée n'est pas au bon format. Ex : toto@toto.fr"
                retour=$?
	done
        #Si l'utilisateur a appuyé sur annuler, on quitte la fonction de backup
        if [ $retour -eq 1 ]; then
            affiche_message "Annulation" "L'opération a bien été annulée"
        fi
}

######################################################################################################################################################
#                                       Fonction qui affiche une fenêtre qui permet la saisie de mot de passe                                        #
######################################################################################################################################################
#Cette fonction permet d'afficher une fenêtre de saisie de mot de passe. $1 correspond au titre et $2 correspond a l indication donné à l utilisateur
function affiche_saisie_mdp(){
        saisie=`$DIALOG --stdout --title "$1" --clear --passwordbox "$2" 16 51`
        retour=$?
	#On boucle tant que l'utilisateur ne saisi pas son mot de passe
        while [[ -z "$saisie" && ! "$retour" -eq 1 ]]; do
                affiche_saisie_mdp "$1" "$2"
                retour=$?
        done
        #Si l'utilisateur a appuyé sur annuler, on quitte la fonction de backup
        if [ $retour -eq 1 ]; then
            affiche_message "Annulation" "L'opération a bien été annulée"
        fi
}

######################################################################################################################################################
#                                       Fonction qui affiche une fenêtre qui permet la saisie du dossier de backup                                   #
######################################################################################################################################################
#Cette fonction permet d'afficher une fenêtre de saisie pour selectionner le dossier de backup. $1 correspond au titre et $2 correspond a l indication donné à l utilisateur
function affiche_saisie_backup(){
        saisie=`$DIALOG --stdout --title "$1" --clear --inputbox "$2" 16 51`
	retour=$?
        #On choisit le dossier par défaut si l'utilisateur ne rentre aucun chemin.
	if [ -z $saisie ]; then
        	saisie="/var/backups"
        fi
}
