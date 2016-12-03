#!/bin/bash

# @author Lauren, Matthieu, Benjamin

#Programme qui permet de chiffrer un dossier de backup qui est placé en paramètre
#Le chiffrement est effectué avec une clé privé et public

#######################################################################################################################################################
#                                                               Importation des scripts utilisés                                                      #
#######################################################################################################################################################
source GUI/fenetre.sh

#######################################################################################################################################################
#                                                       Fonction qui permet de chiffrer le dossier de backup                                          #
#######################################################################################################################################################
function chiffrement(){
	if [ $# = 0 ]; then
		affiche_message "Erreur..." "Aucun dossier ou fichier n'a été placé en paramètre"
	else
		if [[ -d $1 || -f $1 ]]; then
			#Si le dossier existe, il faut le chiffrer avec la clé de l'utilisateur
			gpg --encrypt -r "Matthieu" $1
		else
			#Sinon on affiche le message d erreur concernant l inexistance du dossier
			affiche_message "Erreur..." "Le dossier ou le fichier placé en paramètre n'existe pas"
		fi
	fi
}
