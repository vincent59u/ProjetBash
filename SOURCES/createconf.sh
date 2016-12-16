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
	affiche_saisie_init "Choisir le chemin" "Choisissez le chemin et nom du fichier de configuration à créer" "$HOME/"
	if [ $retour -eq 0 ]; then
		#Si l'utilisateur a entré .conf a la fin de son fichier
		if [[ "$saisie" =~ ".conf"$ ]]; then
			saisie=${saisie::-5}
		fi
		touch $saisie.conf >&- 2>&-
		if [ $? -eq 0 ]; then
			while [ $res -eq 0 ]; do
				#On selectionne le fichier a mettre dans le .conf
				affiche_selectionFichier "Veuillez selectionner un fichier/dossier à ajouter au $saisie.conf (nom de dossier sans '/' à la fin)" "$HOME"
				res=$retour
				if [ $res -eq 0 ]; then
					if [[ -z $(cat $saisie.conf | grep $fichier) && ( -f $fichier || -d $fichier ) ]]; then
						`chmod 700 $fichier`
						echo $fichier >> $saisie.conf
					fi
				fi
			done
			if [ $res -eq 0 ]; then
				affiche_message "Fichier sauvegardé" "Votre fichier de configuration a bien été sauvegardé. Il est désormais prêt à l'emploi."
			fi
		else
			#On indique à l'utilisateur quon ne peut pas créer le fichier de conf
			affiche_message "Erreur..." "Une erreur s'est produite lors de la création du fichier de configuration. Vous ne disposez peut pas des permissions afin d'enregister le fichier à l'endroit souhaité."
		fi
	fi
}
