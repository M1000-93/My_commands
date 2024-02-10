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
			delete_folder_from_config -g "$var_delete_folder" # Appel à la fonction delete_folder_from_config pour supprimer le dossier de conf

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
			delete_folder_from_config -i "$var_delete_folder" # Appel à la fonction delete_folder_from_config pour supprimer le dossier de conf

        else

            # Afficher un message d'échec
            echo -e "\033[31mLe dossier n'existe pas dans la configuration.\033[0m"

        fi
    else

		# Afficher un message d'échec
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}

# Fonction pour supprimer un dossier de la configuration
delete_folder_from_config() {
    
    local folder="$2"
    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub
    if [[ " ${github[@]} " =~ " $1 " ]]; then
        
        # Supprimer le dossier de github_folder s'il existe
        local new_github_folder=()
        for item in "${github_folder[@]}"; do
            [[ "$item" != "$folder" ]] && new_github_folder+=("$item")
        done

        # Mettre à jour le fichier de configuration
        github_folder=("${new_github_folder[@]}")
        write_to_param_file

		# Afficher un message de réussite
        echo -e "\033[32mDossier supprimé avec succès !\033[0m"
    
    # Vérifier si l'option spécifiée est Intra
    elif [[ " ${intra[@]} " =~ " $1 " ]]; then
        
        # Boucle à travers tous les éléments de intra_folder
		for ((i=0; i<${#intra_folder[@]}; i++)); do
		    # Récupérer l'élément actuel de intra_folder
		    local item="${intra_folder[$i]}"
		
		    # Vérifier si l'élément actuel est différent du dossier à supprimer
		    if [[ "$item" != "$folder" ]]; then
		        # Si new_intra_folder est vide, initialiser avec l'élément actuel
		        if [ -z "${new_intra_folder[@]}" ]; then
		            new_intra_folder=("$item")
		            new_intra_link=("${var_links_intra[$i]}")
		        else
		            # Si new_intra_folder n'est pas vide, ajouter l'élément actuel à la liste
		            new_intra_folder+=("$item")
		            new_intra_link+=("${var_links_intra[$i]}")
		        fi
		    fi
		done

        # Mettre à jour le fichier de configuration
        intra_folder=("${new_intra_folder[@]}")
        var_links_intra=("${new_intra_link[@]}")
        write_to_param_file

		# Afficher un message de réussite
        echo -e "\033[32mDossier supprimé avec succès !\033[0m"
        
    else

		# Afficher un message d'échec
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}


# Fonction pour supprimer un dossier GitHub ou Intra
delete_folder() {
    
    local folder="$2"
	local previous_location=$(pwd)

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

	cd $previous_location
}