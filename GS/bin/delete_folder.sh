#!/bin/bash

# Inclure les fichiers nécessaires
. $GS_bin/tools_gs.sh
. $GS_bin/path_gs
. $GS_param

# Fonction pour supprimer tous les dossiers GitHub et Intra configurés
delete_all_folders() {
    
    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub ou Intra, ou si aucune option n'est spécifiée
    if [[ " ${github[@]} " =~ " $1 " || -z $1  ]]; then

        # Boucler à travers tous les dossiers GitHub et les supprimer
        for folder in "${github_folder[@]}"; do

            delete_folder -g "$folder"  # Appel à la fonction delete_folder pour chaque dossier GitHub
        
		done
    elif [[ " ${intra[@]} " =~ " $1 " || -z $1  ]]; then

        # Boucler à travers tous les dossiers Intra et les supprimer
        for folder in "${intra_folder[@]}"; do

            delete_folder -i "$folder"  # Appel à la fonction delete_folder pour chaque dossier Intra
        
		done
    else
	
		# Afficher un message d'échec
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}

# Fonction pour supprimer un dossier avec choix
delete_selected_folder() {
    
    source "$GS_param"
    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub
    if [[ " ${github[@]} " =~ " $1 " ]]; then
        
		# Vérifier si un nom de dossier est fourni en argument
        if [[ $2 ]]; then
            var_delete_folder=$2
        else

            # Demander à l'utilisateur le nom du dossier à supprimer parmi ceux enregistrés
            echo "Voici les dossiers déjà enregistrés : \033[32m${github_folder[*]}\033[0m"
            echo -n "Quel est le nom du dossier que vous voulez supprimer ?"
            read -r var_delete_folder

        fi

        # Vérifier si le nom de dossier est valide
        if [[ -z "$var_delete_folder" ]]; then
            echo "Nom de dossier invalide. Opération annulée."
            return
        fi

        # Vérifier si le dossier existe dans github_folder
        if [[ "${github_folder[*]}" =~ "$var_delete_folder"  ]]; then

            # Supprimer le dossier
            delete_folder -g "$var_delete_folder"  # Appel à la fonction delete_folder pour supprimer le dossier

        else

            # Afficher un message d'échec
            echo -e "\033[31mLe dossier n'existe pas dans la configuration.\033[0m"

        fi
    
	# Vérifier si l'option spécifiée est Intra
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		
		# Vérifier si un nom de dossier est fourni en argument
        if [[ $2 ]]; then
            var_delete_folder=$2
        else

            # Demander à l'utilisateur le nom du dossier à supprimer parmi ceux enregistrés
            echo -e "Voici les dossiers déjà enregistrés : \033[32m${intra_folder[*]}\033[0m"
            echo -n "Quel est le nom du dossier que vous voulez supprimer ?"
            read -r var_delete_folder

        fi

        # Vérifier si le nom de dossier est valide
        if [[ -z "$var_delete_folder" ]]; then
            echo "Nom de dossier invalide. Opération annulée."
            return
        fi

        # Vérifier si le dossier existe dans intra_folder
        if [[ "${intra_folder[*]}" =~ "$var_delete_folder"  ]]; then

            # Supprimer le dossier
            delete_folder -i "$var_delete_folder"  # Appel à la fonction delete_folder pour supprimer le dossier

        else

            # Afficher un message d'échec
            echo -e "\033[31mLe dossier n'existe pas dans la configuration.\033[0m"

        fi
    else

		# Afficher un message d'échec
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}

# Fonction pour supprimer un dossier GitHub ou Intra
delete_folder() {
    
    local folder="$2"

    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub
    if [[ " ${github[@]} " =~ " $1 " ]]; then

        echo -e "\033[33mSuppression de $folder...\033[0m"
        rm -rf "$path_folder_github/$folder" > /dev/null 2>&1

		# Vérifie si la suppression a réussi
        if [ $? -eq 0 ]; then
            
			# Afficher un message de réussite
			echo -e "\033[32mSuppression de $folder réussie.\033[0m"
			
        else

			# Afficher un message d'échec
            echo -e "\033[31mÉchec de la suppression de $folder.\033[0m"

        fi
    # Vérifier si l'option spécifiée est Intra
    elif [[ " ${intra[@]} " =~ " $1 " ]]; then
        echo -e "\033[33mSuppression de $folder...\033[0m"

        # Supprimer le dossier
        rm -rf "$path_folder_intra/$folder" > /dev/null 2>&1

		# Vérifie si la suppression a réussi
        if [ $? -eq 0 ]; then
            
			# Afficher un message de réussite
			echo -e "\033[32mSuppression de $folder réussie.\033[0m"

        else
            
			# Afficher un message d'échec
			echo -e "\033[31mÉchec de la suppression de $folder.\033[0m"

        fi

    else

		# Afficher un message d'érreur
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}
