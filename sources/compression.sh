#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#######################################################################################################################################################
#                                                               Importation des scripts utilisés                                                      #
#######################################################################################################################################################
source GUI/fenetre.sh

#######################################################################################################################################################
#                                                        Fonction qui compresse le dossier de backup                                                  #
#######################################################################################################################################################
function compression(){
	if [ $# = 0 ]; then
                affiche_message "Erreur..." "Aucun dossier n'a été placé en paramètre"
        else
		if [ -d $1 ]; then
			#Si le dossier existe, il est compressé
			$(tar -cvf "$1.tar" $1 2>/dev/null) 2>/dev/null
			$(gzip "$1.tar" ) 2>/dev/null
			$(rm "$1.tar" 2>/dev/null) 2>/dev/null
		else
                        #Sinon on affiche le message d erreur concernant l inexistance du dossier
                        affiche_message "Erreur..." "Le dossier placé en paramètre n'existe pas"
                fi
	fi
}
