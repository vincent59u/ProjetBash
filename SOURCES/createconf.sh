#!/bin/bash
source GUI/fenetre.sh
res=0
affiche_saisie_init "Choisir le chemin et le nom de votre fichier .conf" "Chemin et nom de votre fichier sans le .conf" "/home/user/"
if [ $retour -eq 0 ]; then
	while [ $res -eq 0 ]; do 
		affiche_selectionFichier "Veuillez selectionner un fichier à ajouter au $saisie.conf" "/home/user"
		res=$retour
		if [ $res -eq 0 ]; then
			`chmod 700 $fichier`
			echo $fichier >> $saisie.conf
		fi
done
fi

