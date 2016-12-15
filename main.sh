#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Programme principal du projet de backup
#Il permet d afficher une fenêtre avec la liste de choix que l'utilisateur peut effectuer

#######################################################################################################################################################
#								Importation des scripts utilisés						      #
#######################################################################################################################################################
source SOURCES/backup.sh
source SOURCES/chiffrement.sh
source SOURCES/difference.sh
source SOURCES/extrairefichier.sh
source SOURCES/createconf.sh
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
	--menu "Bonjour, ce programme premet la gestion automatique de backups, sécurisé, et permet la récupération d’anciens fichiers, avec possibilité de récupérer des fichiers mis à jour depuis internet de façon sécurisée, tolérant les erreurs. Veuillez choisir une opération à effectuer parmi les options suivantes :" 50 100 8 \
	"Configuration" "Permet de créer un fichier de configuration automatisé depuis l'application" \
	"Backup" "Faire un backup des fichiers et les envoyer sur le serveur" \
	"Comparer" "Comparer deux backups (différences entre ajout et suppression)" \
	"Récuperer" "Récuperer un fichier ou un dossier d'un backup" \
	"Upload" "Uploader un backups sur le serveur" \
	"Télécgarger" "Télécharger un backups qui se trouve sur le serveur" 2> $fichtemp

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
	#On vérifie que l'utilisateur n a pas appuyer sur annuler, sinon on lui affiche un message d annulation
	if [ $retour -eq 0 ]; then
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
	fi
}

#Fonction qui permet de créer une clef de chiffrement si l'utilisateur en a aucune.
function creationClef(){
	#Appel de la fenêtre de dialog qui permet de saisir son nom.
       	affiche_saisie "Saisir votre nom" "Une clef de chiffrement va être créer, merci de bien vouloir nous fournir vos informations afin de générer cette dernère.\nVeuillez saisir votre nom complet. Ex : Jacques DURANT"
       	#On affecte la valeur saisie à la variable nom.
        nom=$saisie
	#Suite de if qui test à chaque fois que l'opération du dessus s est bien passé afin de quitté le programme sans probleme si l utilisateur appuie sur annuler
	if [ ! $retour -eq 1 ]; then
        	#Appel de la fenêtre de dialog qui permet de saisir son mail.
        	affiche_saisie_mail "Saisir votre e-mail" "Veuillez saisir votre adresse mail. Ex : toto@toto.fr"
        	#On affecte la valeur saisie à la variable nom.
        	mail=$saisie
        	if [ ! $retour -eq 1 ]; then
 			#Appel de la fenêtre de dialog qui permet de saisir son mot de passe.
        		affiche_saisie_mdp "Saisir un mot de passe" "Veuillez saisir un mot de passe qui permettra de protéger votre clef."
        		#On affecte la valeur saisie à la variable nom.
        		mdp=$saisie
        		if [ ! $retour -eq 1 ]; then
				#On crée une clef avec les informations donnée par l'utilisateur.
        			creerClef "$nom" "$mail" "$mdp"
			fi
		fi
	fi
}

#Fonction qui permet de récuperer deux chemins de backups afin de faire la différence entre eux
function faireDifference(){
	#Ouvre une première fenetre qui permet de selectionner le premier backup
       	affiche_selectionFichier "Choisissez le premier backup qui sera comparer" "/var/backups"
        backup1=$fichier
        #Si l'utilisateur a accepter, on continue
        if [ $retour -eq 0 ]; then
        	#Ouvre une deuxième fenêtre qui permet de selectionner le deuxième backup
                affiche_selectionFichier "Choisissez le deuxième backup qui sera comparer" "/var/backups"
                backup2=$fichier
                #Si l'utilisateur a accepter, on continue
                if [ $retour -eq 0 ]; then
                	#On teste que les deux backups existe (pour pas que l'utilisateur entre un faux chemin). Option -f car un tar.gz (Tous les backups) est consideré co$
                        if [[ -f "$backup1" && -f "$backup2" ]]; then
                        	#On fait la différence des deux backups en appelant la méthode du fichier difference.sh
                                difference $backup1 $backup2
                        else
                                #Sinon on indique à l'utilisateur que les chemin entrés ne corresponde pas à un backup (erreur ou dossier)
				affiche_message "Erreur..." "Un des chemins (ou les deux) ne correspond pas à un backups, veuillez réessayer en vous assurant que le vous sélectionnez bien des fichier de backups"
			fi
		fi
	fi
}

#######################################################################################################################################################
#                                                               Switch sur le choix de l'utilisateur                                                  #
#######################################################################################################################################################
case $option in
#Option Valider
0)	#Bloc if qui permet de trouver l option sélectionnée par l utilisateur
	#L utilisateur souhaite faire un fichier de configuration
	if [ "$choix" == "Configuration" ]; then
		#Appel de la fonction qui permet de créer un fichier de backup
		createConf
	#L utilisateur souhaite faire un backup
	elif [ "$choix" == "Backup" ]; then
		#Switch sur le retour de la fenêtre de dialog
		case $? in
			0)
				#On initialise la variable retour à 0 afin que le programme s'execute lorsque l utilisateur possède déjà une clef.
				retour=0
				#Avant de lancer un backup, on s'assure que l utilisateur à une clef de chiffrement. Si c est pas le cas on lui en crée.
				#Pour ce test, on place le resultat de la commande qui liste les clef secrete dans une variable
				clef=`gpg --list-secret-key`
				#Si cette variable est vide, on crée une paire de clefs de chiffrement.
				if [ -z "$clef" ]; then
					creationClef
				fi
				#Si la création de la clef s'est bien passé, on peut créer un backup.
				if [ ! $retour -eq 1 ]; then
					#Appel d'une boite de dialogue pour choisir le fichier de configuration
		                	affiche_selectionFichier "Choisissez le fichier de configuration" "$HOME"
					#On lance le processus qui permet de faire un backup
					lancer_backup "$fichier"
				fi;;
			1)
				#On affiche le message d annulation à l utilisateur si il choisit l'option Annuler
				affiche_message "Annulation" "L'opération a bien été annulée";;
			255)
				#On affiche le message d annulation à l utilisateur si il appuye sur la touche echap
				affiche_message "Annulation" "L'opération à bien été annulée";;
		esac
	#L utilisateur souhaite comparer deux backups
	elif [ "$choix" == "Comparer" ]; then
		#Appel de la fonction qui permet de traiter une différence entre backups.
		faireDifference
	#L'utilisateur souhaite récuperer un dossier ou un fichier dans un backup.
	elif [ "$choix" == "Récuperer" ]; then
		#On appel la fonction d'extraction de fichier ou dossier.
		extraireFichier
	fi;;
#Option Annuler
1) 	#clear
	echo "Au revoir..";;
#Option Echap
255) 	#clear
	echo "Au revoir..";;
esac
