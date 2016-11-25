#!/bin/sh

#Création de la fenêtre de dialogue
DIALOG=${DIALOG=dialog}

#Création d'un fichier temporaire qui permet de stockage de l'option choisi par l'utilisateur
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15

#Personnalisation de la fenêtre de dialog avec différentes options (titre, menu, liste des options...)
$DIALOG --clear --title "Programme de backups de Laurène, Benjamin et Matthieu" \
	--menu "Bonjour, ce programme premet la gestion automatique de backups, sécurisé, et permet la récupération d’anciens fichiers, avec possibilité de récupérer des fichiers mis à jour depuis internet de façon sécurisée, tolérant les erreurs. Veuillez choisir une opération à effectuer parmi les options suivantes :" 50 80 8 \
	 "Faire une backup" "Sauvegarder des fichiers sur le serveur" 2> $fichtemp

#Récupération de l'option choisi (Valider / Annuler)
option=$?
#On récupère l'opération que l'utilisateur souhaite faire
choix=`cat $fichtemp`

#Switch qui permet d'appeler les différentes fonctions du programme en fonction des options
case $option in
#Option Valider
 0)	echo "Faire opération : '$choix'";;
#Option Annuler
1) 	echo "Appuyé sur Annuler.";;
#Option échap
255) 	echo "Appuyé sur Echap.";;
esac
