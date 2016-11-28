#!/bin/bash
#Programme qui permet de chiffrer le dossier qui est placé en paramètre

#Importation des scripts utilisés
source message.sh

dossier=$1

function render_mdp()
{
 	exec 3>&1
  	mdp=$(dialog --clear --title "Saisir mot de passe" --clear --insecure --passwordbox "Veuillez saisir votre mot de passe :" 20 30 2>&1 1>&3)
 	exit_code=$?
	exec 3>&-
}

if [ $# = 0 ]; then
	affiche_message "Erreur..." "Aucun dossier n'a été placé en paramètre"
else
	if [ -d $1 ]; then
		#Si le dossier existe, on affiche la boite de dialogue de saisie du mot de passe
		render_mdp
		#Si la saisie s'est bien passé
		if [ $exit_code = 0 ]; then
			#Chriffrage du dossier de backup
			gpg --yes --batch --passphrase="$mdp" -c $1
			#On supprime le dossier de base pour plus de sécurité
			rmdir $1
			affiche_message "Succès!" "Le dossier a été chiffré avec succès"
		else
			#Sinon on affiche un message d'erreur
			affiche_message "Erreur..." "Il y a eu un probléme lors de la saisie du mot de passe"
		fi
	else
		#Sinon on affiche le message d'erreur concernant l'existance du fichier
		affiche_message "Erreur..." "Le fichier placé en paramètre n'existe pas"
	fi
fi
