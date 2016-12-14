#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Ce programme permet d extraire un fichier d une archive de backup.

#######################################################################################################################################################
#                                                               Importation des scripts utilisés                                                      #
#######################################################################################################################################################
source GUI/fenetre.sh

#######################################################################################################################################################
#                                                               Fonction d'extraction de fichier                                                      #
#######################################################################################################################################################

#Fonction qui permet d'extraire un fichier d une archive
function extraireFichier(){
	#On demande à l'utilisateur de choisir le dossier qui contient le fichier à extraire. Par défaut les backups se trouve dans le dossier /var/backups
	affiche_selectionFichier "Veuillez selectionner un dossier contenant un backup" "/var/backups" #Retourne $fichier
	if [ $retour -eq 0 ]; then
			#Si le fichier fini par tar.gz
		if [[ "$fichier" =~ '.tar.gz'$ ]]; then
		#Choix du fichier à saisir
		affiche_saisie "Choisir fichier à extraire de $fichier" "Choisissez le fichier ou le dossier que vous souhaitez extraire de ce backup"
		fich=$saisie #saisie est le retour de affiche_saisie
		#On recupere le chemin complet du fichier
		chemincomplet=$(tar tf $fichier | grep $fich)
		if [ ! -z $chemincomplet ]; then
		#Si l'utilisateur a bien appuyé sur Accepter et non Annuler
			if [ $retour -eq 0 ]; then
				#On choisit la destination ( pour éviter qu'il ecrase un fichier existant )
				affiche_saisie "Choisir chemin pour votre fichier" "Choisissez le chemin vers le dossier dans lequel vous souhaitez enregistrer le fichier ou dossier extrait"
				if [[ "$saisie" =~ '/'$ ]]; then
				saisie=${saisie::-1}
				fi
				#S'il a choisit Accepter
				if [ $retour -eq 0 ]; then
					destination=($saisie)
					#On demande le mot de passe qui sera utile pour le dechiffrement du fichier
					affiche_saisie_mdp "Entrez votre mot de passe" "Veuillez entrez votre mot de passe afin de pouvoir déchiffrer le fichier ou dossier que vous souhaitez récuperer"
					#Si l'utilisateur à choisi accepter
					if [ $retour -eq 0 ]; then
						depth=$(awk -F/ '{print NF-1}' <<< "$chemincomplet")
						tar xfvz $fichier -C $destination --strip-components="$depth" "$chemincomplet" >&- 2>&-
						#On se déplace ver le dossier
						cheminactuel=$PWD
						cd $destination
						#On decrypte le fichier
						gpg --output $fich --batch --yes --passphrase $saisie --decrypt $fich.gpg >&- 2>&-
						#On supprime son .gpg
						rm "$fich.gpg"
						cd $cheminactuel
						affiche_message "Extraction effectué" "Votre fichier est pret dans $destination"
					fi
				fi
			fi
			else
			#Si le fichier choisit n'existe pas dans le repertoire
			affiche_message "Fichier incorrect ou inexistant" "Votre nom de fichier est incorrect ou inexistant"
			fi
		else
			#Si le fichier n'est pas un tar.gz
			affiche_message "L archive n existe pas" "Votre archive n est pas reconnu ou existante" 
		fi
	fi
}

