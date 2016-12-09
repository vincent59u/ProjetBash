#!/bin/bash

# @author Laurene, Matthieu, Benjamin

#Programme qui permet de supprimer les anciens backups
#Les 100 derniers backups du dossier seront souvegarder. La différence est faite au niveau des timestamp

#######################################################################################################################################################
#                        Fonction qui supprime automatiquement les plus anciens backups lorsqu'il y en a plus de 100                                  #
#######################################################################################################################################################
#Fonction qui permet de supprimer progressivement les anciens backups. $1 correspond au dossier qui contient les backups.
function supprimerAnciensBackups(){
	#On compte (wc -l) ici le nombre de fichier (param f)
       	nbfichier=$(find $1 -type f | wc -l )
        #S'il y a plus de 100 dossier de backups dans /var/backups/
        if [ $nbfichier -gt 100 ]; then
                #On cherche le plus ancien
                suppr=$(ls $1 -tr1 | head -n 1)
                #On le supprime
                rm $1/$suppr
        fi
}
