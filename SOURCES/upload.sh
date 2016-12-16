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
	regexhash="^[a-z0-9]+$" #regex pour le hash
	regexfichier="\([A-Za-z0-9\/\.]+\)" #regex pour le fichier
	fichiersgz=$(cat "$HOME/hashsauvegarde.txt" | grep -oE $regexfichier)
	fichiersgz=$(echo $fichiersgz | grep -oE "[0-9]+\.tar\.gz") #Les fichiers .tar.gz
	hashs=$(cat "$HOME/hashsauvegarde.txt" | grep -oE $regexhash) #Les hashs 
	arr=($fichiersgz) #On stocke les fichiers dans un tableau
	arr2=($hashs) #On stocke les hashs dans un tableau
	vartest=""
	for ((i=0;i<${#arr[@]};++i)); do
		vartest=$vartest"${arr2[i]} ${arr[i]} " #On concatene hashs puis fichier puis hashs puis fichier...
	done
	hash=$(dialog --stdout --title "Telechargement backup" --menu "Hash et fichier" 0 0 0 $vartest)  #On cree un menu pour choisir le fichier et on recup le hash
	echo $hash
	currentlocation=$PWD
	cd "/var/backups" #On stocke les fichiers dans le dossier de backup
	affiche_saisie "Choisir nom pour votre fichier .tar.gz" "Nom sans tar.gz"
	if [ $retour -eq 0 ]; then
		curl -o $saisie".tar.gz" https://daenerys.xplod.fr/backup/download.php?login=Cladt_Rath_Vincent\&hash=$hash #On dl le fichier !!!!!!!!! HASH PAS RECCONU !!!!!!!
		if [ $? -eq 0 ]; then
			cd $currentlocation
			affiche_message "Fichier telechargé" "A retrouver dans /var/backups"
		else
			cd $currentlocation
			affiche_message "Erreur Curl" "Un erreur avec Curl est survenu"
		fi
	else
		cd $currentlocation
		affiche_message "Erreur" "Vous n'avez pas entré de nom pour votre fichier"
	fi
}

