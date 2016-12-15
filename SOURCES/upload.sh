#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Fonction permettant l'upload de backup sur daenerys

##############################################################################################################################
#			Importation des scripts utilisés								     #
##############################################################################################################################
source GUI/fenetre.sh

##############################################################################################################################
#			Fonction d upload d un fichier sur le serveur 							     #
##############################################################################################################################

function uploadBackup(){
affiche_selectionFichier "Veuillez selectionner le backup que vous souhaitez upload" "/var/backups" #Retourne $fichier
if [[ "$fichier" =~ '.tar.gz'$ ]]; then
	regex="\=[a-z0-9]+"
	#Upload du fichier ( LE NOM DU GROUPE EST Cladt_Rath_Vincent )
	hash=$(curl -F file=@"$fichier"  https://daenerys.xplod.fr/backup/upload.php?login=Cladt_Rath_Vincent)
	if [ $? = 0 ]; then
		#On récupère le hash retrouné
		hash=$(echo $hash | grep -oE $regex )
		#On enlève le = devant
		hash=$(echo $hash | grep -oE "[a-z0-9]+")
		#On met le login dans le fichier de save
		echo "#Cladt_Rath_Vincent#" >> "$HOME/hashsauvegarde.txt"
		echo "($fichier)" >> "$HOME/hashsauvegarde.txt"
		#On met le hash dans le fichier de save
		echo $hash >> "$HOME/hashsauvegarde.txt"
		affiche_message "Fichier uploadé avec succés" "Login : Cladt_Rath_Vincent \n Hash = $hash\n Recapitulatif de vos backups dans /home/user/hashsauvegarde.txt"
	else
		affiche_message "Problème avec Curl" "Erreur avec Curl"
	fi
else
	affiche_message "Erreur avec le fichier" "Le fichier n'est pas un backup .tar.gz"
fi
}

##############################################################################################################################
#                       Fonction qui permet de lister les backups en ligne                                                   #
##############################################################################################################################
#Utile pour la récup
#curl https://daenerys.xplod.fr/backup/list.php?login=Cladt_Rath_Vincent
function listerBackup(){
	curl https://daenerys.xplod.fr/backup/list.php?login=Cladt_Rath_Vincent
}

##############################################################################################################################
#                       Fonction qui permet de télécharger un backups en ligne                                               #
##############################################################################################################################
#Fonctuion qui nous permet de récuper un backup qui a été uploader sur le serveur
function downloadBackup(){
	#IFS=$'\n'
	regexhash="^[a-z0-9]+$"
	regexfichier="\([A-Za-z0-9\/\.]+\)"
	fichiersgz=$(cat "$HOME/hashsauvegarde.txt" | grep -oE $regexfichier)
	fichiersgz=$(echo $fichiersgz | grep -oE "[0-9]+\.tar\.gz")
	hashs=$(cat "$HOME/hashsauvegarde.txt" | grep -oE $regexhash)
	echo $fichiersgz  #Le noms des fichiers présents sur daenerys
	echo $hashs #La liste de tout les hashs présents sur le serveur daenerys

}

