#!/bin/bash
source GUI/fenetre.sh
#Cette variable teste si le programme doit continuer
res=0
#On cherche le .conf
affiche_saisie_init "Choisir le chemin et le nom de votre fichier .conf" "Chemin et nom de votre fichier sans le .conf" "/home/user/"
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
fi
affiche_message "Votre fichier .conf est prêt à l'emploi" "Fichier .conf sauvegardé"
