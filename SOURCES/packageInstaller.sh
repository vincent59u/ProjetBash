#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Ce programme permt d'installer automatiquement les packages manquant.
#######################################################################################################################################################
#                                                               Importation des scripts utilisés                                                      #
#######################################################################################################################################################
source GUI/fenetre.sh

#######################################################################################################################################################
#                                                               Fonction d'affichage des messages                                                     #
#######################################################################################################################################################
#Fonction indique qu'un package est manquant et on demande une installation en tant que ROOT.
function packageManquant(){
        affiche_message_exit "Erreur..." "Merci de bien vouloir executer ce programme en temps que root afin d'installer les packages nécessaire."
}

#Si les packages se sont pas bien installer, on quitte le programme et on dit à l'utilisateur de les installer manuellement.
function erreurInstallation(){
	affiche_message_exit "Erreur..." "Un problème est survenu lors de l'installation des packages manquants. Veuillez réessayer manuellement.\n\nLe programme a besoin des packages dialog, gnupg et sendmail pour fonctionner."
}

#######################################################################################################################################################
#                                                               Vérification succès de l'installation                                                 #
#######################################################################################################################################################
#On vérifie si tous les package soit bien installé sinon on indique a l'utilisateur qu il y a eu un problème et le programme quitte.
#Sinon on affiche un message qui indique qu'il y a eu une erreur. On quitte le programme ensuite.
function verifierInstallation(){
	if ! dpkg -s dialog > /dev/null 2>&1; then
	        erreurInstallation
	fi

	if ! dpkg -s gnupg > /dev/null 2>&1; then
	        erreurInstallation
	fi

	if ! dpkg -s sendmail > /dev/null 2>&1; then
	        erreurInstallation
	fi
}

#######################################################################################################################################################
#                                                               Vérification des packages installés                                                   #
#######################################################################################################################################################
#Vérifie l'ensembles des packages nécessaires au lancement du programme
function verifierPackage(){
	#Si le package dialog n'est pas installé
	if ! dpkg -s dialog > /dev/null 2>&1; then
	        #Si on est connecté en root
	        if [ $(id -u) -eq 0 ]; then
	                #on installe le package manquant
	                apt-get install dialog
	        else
	                #Sinon on dit à l'utilisateur que le programme doit être lancer en root
			packageManquant
	        fi
	fi

	#Si le package gnupg n'est pas installé
	if ! dpkg -s gnupg > /dev/null 2>&1; then
	        #Si on est connecté en root
	        if [ $(id -u) -eq 0 ]; then
	                #on installe le package manquant
	                apt-get install gnupg
	        else
	                #Sinon on dit à l'utilisateur que le programme doit être lancer en root
	        	packageManquant
		fi
	fi

	#Si le package sendmail n'est pas installé
	if ! dpkg -s sendmail > /dev/null 2>&1; then
	        #Si on est connecté en root
	        if [ $(id -u) -eq 0 ]; then
			#Comme le package sendmail ne peut pas s'installer sans sendmail-bin, on installe celui-ci avant
			apt-get install sendmail-bin
	                #on installe le package manquant
	                apt-get install sendmail
	        else
	                #Sinon on dit à l'utilisateur que le programme doit être lancer en root
			packageManquant
	        fi
	fi

	#On vérifie que les packages se sont bien installés.
	verifierInstallation
}
