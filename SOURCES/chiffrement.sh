#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Programme qui permet de chiffrer un dossier de backup qui est placé en paramètre. Le programme contient également deux fonctions qui permettent
#de vérifier que l'utilisateur possède une clef et de la créer le cas ou il y en a aucune.
#Le chiffrement est effectué avec une clé privé et public

#######################################################################################################################################################
#                                                               Importation des scripts utilisés                                                      #
#######################################################################################################################################################
source GUI/fenetre.sh
source SOURCES/interruption.sh

#######################################################################################################################################################
#                                               Fonction qui vérifie si l'utilisateur possède déjà une clef                                           #
#######################################################################################################################################################
#fonction qui permet de créer une clef de chiffrement à l'utilisateur. $1 correspond au nom de la personne
#								       $2 correspond à l'adresse mail de la personne
#								       $3 corrspond au mot de passe de l'utilisateur
function creerClef(){
	# /!\ Gestion du cas de l' ENTROPIE /!\
	affiche_message_info "Création de votre clef de chiffrement" "Votre clef de chiffrement vas être générée, cela peut prendre plusieurs minutes.\n\n Merci de bien vouloir générer de l'entropie en bougeant votre souris et en appuyant sur des touches.\n\n Si l'opération prend beaucoup de temps, quitter le programme (ctrl+c) puis lancez la commande suivante en tant que root : rm /dev/random && ln -s /dev/urandom /dev/random. Appuyez sur entrer pour continuer."
	#Durant tout le processus, on vérifie si l'utilisateur veut quitter le programme.
	trap ctrl_c INT
	#Un fichier de configuration est créé. Il contient les infos important pour créer un couple de clef en mode batch
	touch conf
#On ajoute toutes les informations nécessaire à la création d'une clef par défaut dans le fichier de configuration
cat >conf <<EOF
	    Key-Type: RSA
	    Key-Length: 2048
	    Subkey-Type: RSA
	    Subkey-Length: 2048
	    Name-Real: $1
	    Name-Email: $2
	    Name-comment: ""
	    Expire-Date: 0
	    Passphrase: $3
	    %pubring clef.pub
	    %secring clef.sec
EOF
	#On crée la clef en mode batch avec les options du fichier de configuration placé en paramètre
	gpg --batch --gen-key conf >&- 2>&-
	#On importe les deux clef (publique et privé) au trousseau de l'utilisateur
	gpg --import clef.pub >&- 2>&-
	gpg --import clef.sec >&- 2>&-
	#On arrête le trapping de l'interruption
	trap "" INT
	#On supprime le fichier de configuration et les deux clefs créer pour un gain de place évident
	rm conf clef.pub clef.sec
	#Affiche du message de succès
	affiche_message_info "Succès" "Votre clef est prête, appuyez sur entrer pour créer votre backup."
}

#######################################################################################################################################################
#                                                       Fonction qui permet de chiffrer le dossier de backup                                          #
#######################################################################################################################################################
function chiffrement(){
        #Si aucun fichier ou dossier n'es placé en paramètre, on affiche un message d erreur
	if [ $# = 0 ]; then
                affiche_message "Erreur..." "Aucun dossier ou fichier n'a été placé en paramètre"
        else
		#Si le dossier ou le fichier placé en paramètre existe, on le chiffe
                if [[ -d $1 || -f $1 ]]; then
                        #Si le dossier ou le fichier existe, il faut le chiffrer avec la clé de l'utilisateur
                        gpg --encrypt --default-recipient-self $1
                else
                        #Sinon on affiche le message d erreur concernant l inexistance du dossier
                        affiche_message "Erreur..." "Le dossier ou le fichier placé en paramètre n'existe pas"
                fi
        fi
}
