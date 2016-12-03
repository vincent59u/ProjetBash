#!/bin/bash

# @author Lauren, Matthieu, Benjamin

#Programme qui permet de supprimer des anciens fichier dans le dossier de backup
#Le dossier de backup conservera les 100 derniers fichiers du dossier

#######################################################################################################################################################
#                        Fonction qui supprime automatiquement les plus anciens backups lorsqu'il y en a plus de 100                                  #
#######################################################################################################################################################
function supprimerAnciensFichiers(){
	#On compte (wc -l)  ici le nombre de fichier (param f) du dossier
       	nbfichiers=$(find /var/backups -type f | wc -l )
        #S'il y a plus de 100 fichiers dans le dossier
        if [ $nbfichiers -gt 100 ]; then
                #On cherche le plus ancien
                suppr=$(ls /var/backups -tr1 | head -n 1)
                #On le supprime
                rm /var/backups/$suppr
        fi
}
