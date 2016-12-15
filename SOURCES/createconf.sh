#!/bin/bash

# @author Laurne, Matthieu, Benjamin

#Ce programme permet d'ajouter ou de créer un .conf

################################################################################################################################
#							Importation des scripts utilisés				       #
################################################################################################################################
source GUI/fenetre.sh

################################################################################################################################
#							Fonction de création ou d ajout d un .conf			       #
################################################################################################################################

function createConf(){
	#Cette variable teste si le programme doit continuer
	res=0
	#On cherche le .conf
	affiche_saisie_init "Choisir le chemin" "Choisissez le chemin et nom de votre fichier de configuration sans l'extension .conf" "/home/user/"
	if [ $retour -eq 0 ]; then
		#Si l'utilisateur a tout de même entrer .conf a la fin de son fichier
		if [[ "$saisie" =~ ".conf"$ ]]; then
			saisie=${saisie::-5}
		fi
		while [ $res -eq 0 ]; do
			#On selectionne le fichier a mettre dans le .conf
			affiche_selectionFichier "Veuillez selectionner un fichier à ajouter au $saisie.conf" "/home/user"
			res=$retour
			if [ $res -eq 0 ]; then
				if [[ -z $(cat $saisie.conf | grep $fichier) && ( -f $fichier ) ]]; then
					`chmod 700 $fichier`
					echo $fichier >> $saisie.conf
				fi
			fi
		done
		affiche_message "Fichier sauvegardé" "Votre fichier de configuration a bien été sauvegardé. Il est désormais prêt à l'emploi."
	fi
}
