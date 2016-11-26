#!/bin/bash
# On compte (wc -l)  ici le nombre de fichier (param f) du dossier
nbfichiers=$(find /var/backups -type f | wc -l )
echo "Nombre de fichiers du dossier : $nbfichiers"
        #S'il y a plus de 100 fichiers
        if [ $nbfichiers -gt 100 ]; then
        echo "Suppression du fichier le plus vieux"
        #On cherche celui a supprimer
        suppr=$(ls /var/backups -tr1 | head -n 1)
        echo "Le fichier le plus vieux est : $suppr"
        #On le supprime
        rm /var/backups/$suppr
        fi
