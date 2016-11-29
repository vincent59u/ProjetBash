#!/bin/bash

#Importation des scripts utilisés
source sources/message.sh
source sources/backup.sh

#Création de la fenêtre de dialogue
DIALOG=${DIALOG=dialog}

#Fonction qui affiche la fenêtre de dialogue qui permet la sélection du fichier de configuration
function render_selection(){
	selection=`$DIALOG --stdout --title "Choisissez le fichier de configuration" --fselect $HOME/ 14 48`
}

#Fonction qui permet à l'utilisateur de saisir le nom de son fichier de confugration
function render_saisie(){
	saisie=`$DIALOG --stdout --title "Saisir un nom de fichier" --inputbox "Veuillez saisir le nom de votre fichier de configuration :" 10 62`
}

#Création d'un fichier temporaire qui permet de stockage de l'option choisi par l'utilisateur
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15

#Personnalisation de la fenêtre de dialog avec différentes options (titre, menu, liste des options...)
$DIALOG --clear --title "Programme de backups de Laurene, Benjamin et Matthieu" \
	--menu "Bonjour, ce programme premet la gestion automatique de backups, sécurisé, et permet la récupération d’anciens fichiers, avec possibilité de récupérer des fichiers mis à jour depuis internet de façon sécurisée, tolérant les erreurs. Veuillez choisir une opération à effectuer parmi les options suivantes :" 50 80 8 \
	"Configuration" "Créer un fichier de configuration" \
	"Backup" "Faire un backup des fichiers et les envoyer sur le serveur" 2> $fichtemp

#Récupération de l'option choisi (Valider / Annuler)
option=$?
#On récupère l'opération que l'utilisateur souhaite faire
choix=`cat $fichtemp`

#Switch qui permet d'appeler les différentes fonctions du programme en fonction des options
case $option in
#Option Valider
0)	#Bloc if qui permet de trouver l'option sélectionnée par l'utilisateur
	if [ "$choix" == "Configuration" ]; then
		#Demander le nom du fichier
		render_saisie
		fichierconf=$saisie.conf
		#Remplir le fichier aves les nom des fichiers et / ou dossiers à sauvegarder
		echo $fichierconf
	elif [ "$choix" == "Backup" ]; then
		#Appel d'une boite de dialogue pour choisir le fichier de configuration
		render_selection
		#Switch sur le retour de la fenêtre de dialog
		case $? in
			0)
				#Appeler le .sh de backup avec le fichier de configuration en paramètre
				backup $fichier;;
			1)
				#On affiche le message d'annulation à l'utilisateur
				affiche_message "Annulation" "L'opération a bien été annulée";;
			255)
				#On affiche le message d'annulation à l'utilisateur
				affiche_message "Annulation" "L'opération à bien été annulée";;
		esac
	fi;;
#Option Annuler
1) 	echo "Au revoir..";;
#Option échap
255) 	echo "Au revoir..";;
esac
