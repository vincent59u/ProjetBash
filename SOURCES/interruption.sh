#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Programme qui permet de réaliser une intéruption lorsque l'utilisateur appuye sur ctrl+c
#######################################################################################################################################################
#                                                               Importation des scripts utilisés                                                      #
#######################################################################################################################################################
source GUI/fenetre.sh

#######################################################################################################################################################
#                                                               Function qui réalise une interruption                                                 #
#######################################################################################################################################################
#Si l'utilisateur appuye sur ctr+c, on fait le traitement suivant.
function ctrl_c() {
        affiche_message_info "Vous avez quitté" "Vous venez de quitter le programme de génération de clef de chiffrement.\n\n Merci de lancer la commande suivante en tant que root : rm /dev/random && ln -s /dev/urandom /dev/random.\n\n Cette commande permet de générer de l'entropie.\n\n Rééssayez ensuite."
	exit
}
