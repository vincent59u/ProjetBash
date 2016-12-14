#!/bin/bash

#installer sendmail (apt-get install sendmail) au préalable (cf. sujet)

#Fonction qui envoie un email à l'utilisateur (accessible grace à la commande "mail"), avec le message d'erreur précisé en paramètre $1
function errorEmail(){
	#Ajoute le sujet du message
	echo "Subject: Message d'erreur" > mail.txt
	#Écrit le message spécifié en paramètre dans l'email
	echo "$1" >> mail.txt 
	#Envoie l'email à l'utilisateur
	sendmail  -v $USER@$HOSTNAME.home < mail.txt
}
