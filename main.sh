#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Programme principal du projet de backup
#Il permet d afficher une fenêtre avec la liste de choix que l'utilisateur peut effectuer

#######################################################################################################################################################
#								Importation des scripts utilisés						      #
#######################################################################################################################################################
source sources/message.sh
source sources/backup.sh
source GUI/fenetre.sh

#######################################################################################################################################################
#								Création de la fenêtre de dialogue						      #
#######################################################################################################################################################

DIALOG=${DIALOG=dialog}

#Création d un fichier temporaire qui permet de stockage de l option choisi par l utilisateur
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15

#Personnalisation de la fenêtre de dialog avec différentes options (titre, menu, liste des options...)
$DIALOG --clear --title "Programme de backups de Laurene, Benjamin et Matthieu" \
	--menu "Bonjour, ce programme premet la gestion automatique de backups, sécurisé, et permet la récupération d’anciens fichiers, avec possibilité de récupérer des fichiers mis à jour depuis internet de façon sécurisée, tolérant les erreurs. Veuillez choisir une opération à effectuer parmi les options suivantes :" 50 80 8 \
	"Backup" "Faire un backup des fichiers et les envoyer sur le serveur" 2> $fichtemp

#######################################################################################################################################################
#                                                               Récupération des options séléctionnées                                                #
#######################################################################################################################################################

#Récupération de l'option choisie dans la fenêtre principale (Valider / Annuler)
option=$?
#On récupère l opération que l utilisateur souhaite faire
choix=`cat $fichtemp`

#######################################################################################################################################################
#                                                               Switch sur le choix de l'utilisateur                                                  #
#######################################################################################################################################################
case $option in
#Option Valider
0)	#Bloc if qui permet de trouver l option sélectionnée par l utilisateur
	if [ "$choix" == "Backup" ]; then
		#Appel d'une boite de dialogue pour choisir le fichier de configuration
		affiche_selectionFichier
		#Switch sur le retour de la fenêtre de dialog
		case $? in
			0)
				#Appel du script qui permet de faire de backup avec le fichier de configuration en placé paramètre
				backup $fichier;;
			1)
				#On affiche le message d annulation à l utilisateur si il choisit l'option Annuler
				affiche_message "Annulation" "L'opération a bien été annulée";;
			255)
				#On affiche le message d annulation à l utilisateur si il appuye sur la touche echap
				affiche_message "Annulation" "L'opération à bien été annulée";;
		esac
	fi;;
#Option Annuler
1) 	echo "Au revoir..";;
#Option Echap
255) 	echo "Au revoir..";;
esac
