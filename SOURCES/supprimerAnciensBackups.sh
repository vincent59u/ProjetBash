#!/bin/bash

# @author Lauren, Matthieu, Benjamin

#Programme qui permet de supprimer les anciens backups
#Les 100 derniers backups du dossier seront souvegarder. La différence est faite au niveau des timestamp

#######################################################################################################################################################
#                        Fonction qui supprime automatiquement les plus anciens backups lorsqu'il y en a plus de 100                                  #
#######################################################################################################################################################
function supprimerAnciensBackups(){
	#On compte (wc -l) ici le nombre de dossier (param d)
       	nbdossiers=$(find /var/backups/ -type d | wc -l )
        #S'il y a plus de 100 dossier de backups dans /var/backups/
        if [ $nbdossiers -gt 100 ]; then
                #On cherche le plus ancien
                suppr=$(ls /var/backups/ -tr1 | head -n 1)
                #On le supprime
                rm /var/backups/$suppr
        fi
}
