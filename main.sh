#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Programme principal du projet de backup
#Il permet d afficher une fenêtre avec la liste de choix que l'utilisateur peut effectuer

#######################################################################################################################################################
#								Importation des scripts utilisés						      #
#######################################################################################################################################################
source SOURCES/backup.sh
source SOURCES/chiffrement.sh
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
	"Backup" "Faire un backup des fichiers et les envoyer sur le serveur" \
	"Comparer" "Comparer deux backups (différences entre ajout et suppression)" 2> $fichtemp

#######################################################################################################################################################
#                                                               Récupération des options séléctionnées                                                #
#######################################################################################################################################################

#Récupération de l'option choisie dans la fenêtre principale (Valider / Annuler)
option=$?
#On récupère l opération que l utilisateur souhaite faire
choix=`cat $fichtemp`

#######################################################################################################################################################
#                                   Liste des fonctions utilisées dans le switch statement ci dessous                                                 #
#######################################################################################################################################################
#Fonction qui lance le processus qui permet de faire un dossier chiffré, compressé d'un backup
function lancer_backup(){
	#Vérification que le fichier choisi soit un fichier et qu il se termine par l'extension .conf
        if [ -f $1 ]; then
        #On teste que l extension du fichier soit bien .conf (fichier de configuration)
  	      regex="^.+(.conf)$"
              if [[ "$1" =~ $regex ]]; then
             	 #Appel du script qui permet de faire de backup avec le fichier de configuration en placé paramètre
                 backup $1
              else
                 affiche_message "Erreur..." "Le fichier sélectionné n'est pas un fichier de configuration. (extension .conf)"
              fi
        else
              #On indique a l utilisateur que le fichier n est pas correct
              affiche_message "Erreur..." "Vous avez choisis un dossier et non un fichier de configuration ou bien le fichier sélectionné n'existe pas."
        fi
}

#######################################################################################################################################################
#                                                               Switch sur le choix de l'utilisateur                                                  #
#######################################################################################################################################################
case $option in
#Option Valider
0)	#Bloc if qui permet de trouver l option sélectionnée par l utilisateur
	#L utilisateur souhaite faire un backup
	if [ "$choix" == "Backup" ]; then
		#Switch sur le retour de la fenêtre de dialog
		case $? in
			0)
				#Avant de lancer un backup, on s'assure que l utilisateur à une clef de chiffrement. Si c est pas le cas on lui en crée.
				if [ /!\ Faire condition qui test si il y a déjà une clef /!\ ]; then
					#Appel de la fenêtre de dialog qui permet de saisir son nom.
					affiche_saisie "Saisir votre nom" "Veuillez saisir votre nom complet. Ex : Jacques DURANT"
					#On affecte la valeur saisie à la variable nom.
					nom=$saisie
					#Appel de la fenêtre de dialog qui permet de saisir son mail.
                                        affiche_saisie_mail "Saisir votre e-mail" "Veuillez saisir votre adresse mail. Ex : toto@toto.fr"
                                        #On affecte la valeur saisie à la variable nom.
                                        mail=$saisie
					#Appel de la fenêtre de dialog qui permet de saisir son mot de passe.
                                        affiche_saisie_mdp "Saisir un mot de passe" "Veuillez saisir un mot de passe qui permettra de protéger votre clef."
                                        #On affecte la valeur saisie à la variable nom.
                                        mdp=$saisie
					#On crée une clef avec les informations donnée par l'utilisateur.
					creerClef "$nom" "$mail" "$mdp"
				fi
				#Appel d'une boite de dialogue pour choisir le fichier de configuration
		                affiche_selectionFichier "Choisissez le fichier de configuration" "$HOME"
				#On lance le processus qui permet de faire un backup
				lancer_backup "$fichier";;
			1)
				#On affiche le message d annulation à l utilisateur si il choisit l'option Annuler
				affiche_message "Annulation" "L'opération a bien été annulée";;
			255)
				#On affiche le message d annulation à l utilisateur si il appuye sur la touche echap
				affiche_message "Annulation" "L'opération à bien été annulée";;
		esac
	#L utilisateur souhaite comparer deux backups
	elif [ "$choix" == "Comparer" ]; then
		#On ouvre deux fenêtres de selection de fichier afin que l utilisateur choisise deux backups différents afin de faire la différence
		affiche_selectionFichier "Choisissez un fichier de backup à comparer" "/var/backups"
	fi;;
#Option Annuler
1) 	#clear
	echo "Au revoir..";;
#Option Echap
255) 	#clear
	echo "Au revoir..";;
esac
