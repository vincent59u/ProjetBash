#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Ce programme permet d'envoyer des mail à l utilisateur afin de le prévenir du déroulement des backups (erreur et succès)

#######################################################################################################################################################
#							Fonction qui permet d'envoyer un mail (erreur)						      #
#######################################################################################################################################################
#Fonction qui envoie un email à l utilisateur (accessible grace à la commande "mail" si il a installé mailutils), avec le message d'erreur précisé en paramètre $1
function errorEmail(){
	#Ajoute le sujet du message
	echo "Subject: Message d'erreur" > mail.txt
	#Écrit le message spécifié en paramètre dans l'email
	echo "$1" >> mail.txt
	#Envoie l'email à l utilisateur
	sendmail -v $USER@$HOSTNAME.home < mail.txt >&- 2>&-
	rm mail.txt
}

#######################################################################################################################################################
#                                                       Fonction qui permet d'envoyer un mail (erreur Synopsis)                                       #
#######################################################################################################################################################
#Fonction envoyant un email s'il y a eu une erreur lorsqu un fichier de synopsis n est pas valide (Le nom doit être passé en paramètre)
function verificationError(){
	errorEmail "Le fichier de synopsis $1 était invalide; il n'a donc pas été récupéré."
}

#######################################################################################################################################################
#                                                       Fonction qui permet d'envoyer un mail (erreur de connexion)                                   #
#######################################################################################################################################################
#Fonction envoyant un email s'il y a eu des erreurs de connexion ($? doit être passé en paramètre)
function connexionError(){
	if [[ $1 -ge 6 ]]; then
		errorEmail "Erreur de connexion lors de la récupération des synopsis."
	fi
}

