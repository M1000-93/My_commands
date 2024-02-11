#!/bin/bash

. $GS_bin/tools_gs.sh
. $GS_bin/path_gs
. $GS_param

# Fonction pour pull tous les dossiers GitHub et Intra configurés
pull_all_folders() {

	local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub ou Intra, ou si aucune option n'est spécifiée
    if [[ " ${github[@]} " =~ " $1 " || -z $1  ]]; then

        # Boucler à travers tous les dossiers GitHub et les pousser vers leurs dépôts distants
        for folder in "${github_folder[@]}"; do

            pull_folder -g "$folder"  # Appel à la fonction pull_folder pour chaque dossier GitHub
        
		done
    elif [[ " ${intra[@]} " =~ " $1 " || -z $1  ]]; then

        # Boucler à travers tous les dossiers Intra et les pousser vers leurs dépôts distants
        for folder in "${intra_folder[@]}"; do

            pull_folder -i "$folder"  # Appel à la fonction pull_folder pour chaque dossier Intra
        
		done
    else
	
		# Afficher un message d'échec
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}

pull_selected_folder() {

    source "$GS_param"
    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub
    if [[ " ${github[@]} " =~ " $1 " ]]; then
        
		# Vérifier si un nom de dossier est fourni en argument
        if [[ $2 ]]; then
            var_pull_folder=$2
        else

            # Demander à l'utilisateur le nom du dossier à pousser vers son dépôt distant parmi ceux enregistrés
            echo "Voici les dossiers déjà enregistrés : \033[32m${github_folder[*]}\033[0m"
            echo -n "Quel est le nom du dossier que vous voulez pull ? "
            read -r var_pull_folder

        fi

        # Vérifier si le nom de dossier est valide
        if [[ -z "$var_pull_folder" ]]; then
            echo "Nom de dossier invalide. Opération annulée."
            return
        fi

        # Vérifier si le dossier existe dans github_folder
        if [[ "${github_folder[*]}" =~ "$var_pull_folder"  ]]; then

            # Pousser le dossier vers son dépôt distant
            pull_folder -g "$var_pull_folder"  # Appel à la fonction pull_folder pour pousser le dossier vers son dépôt distant

        else

            # Afficher un message d'échec
            echo -e "\033[31mLe dossier n'existe pas dans la configuration.\033[0m"

        fi
    
	# Vérifier si l'option spécifiée est Intra
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		
		echo "ok"
		# Vérifier si un nom de dossier est fourni en argument
        if [[ $2 ]]; then
            var_pull_folder=$2
        else

            # Demander à l'utilisateur le nom du dossier à pousser vers son dépôt distant parmi ceux enregistrés
            echo -e "Voici les dossiers déjà enregistrés : \033[32m${intra_folder[*]}\033[0m"
            echo -n "Quel est le nom du dossier que vous voulez pull ? "
            read -r var_pull_folder
			
        fi

        # Vérifier si le nom de dossier est valide
        if [[ -z "$var_pull_folder" ]]; then
            echo "Nom de dossier invalide. Opération annulée."
            return
        fi

        # Vérifier si le dossier existe dans intra_folder
        if [[ "${intra_folder[*]}" =~ "$var_pull_folder"  ]]; then

            # Pousser le dossier vers son dépôt distant
            pull_folder -i "$var_pull_folder"  # Appel à la fonction pull_folder pour pousser le dossier vers son dépôt distant

        else

            # Afficher un message d'échec
            echo -e "\033[31mLe dossier n'existe pas dans la configuration.\033[0m"

        fi
    else

		# Afficher un message d'échec
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}

pull_folder() {
    
    local folder="$2"
	local previous_location=$(pwd)

    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub
    if [[ " ${github[@]} " =~ " $1 " ]]; then

        echo -e "\033[33mPull du dossier $folder depuis son dépôt distant...\033[0m\n"
       
		# Se déplacer vers le dossier GitHub
	    cd "$path_folder_github/$folder" || return

		# Pull depuis le dépôt distant
        output=git pull origin main > /dev/null 2>&1

		# Vérifie si le pull a réussi
        if [[ "$output" == "Already up to date." ]]; then
            
			# Afficher $output en vert
			echo -e "\033[32m$output\033[0m\n"

		elif [[ -n "$output" ]]; then

			# Afficher $output en blanc
			echo "$output"

        else
            
			# Afficher un message d'échec
			echo -e "\033[31mÉchec du push pour $folder.\033[0m\n"

        fi

    # Vérifier si l'option spécifiée est Intra
    elif [[ " ${intra[@]} " =~ " $1 " ]]; then
        
		echo -e "\033[33mPull du dossier $folder depuis son dépôt distant...\033[0m\n"

        # Se déplacer vers le dossier Intra
        cd "$path_folder_intra/$folder" || return  

        # Pull depuis le dépôt distant
        output=$(git pull origin main > /dev/null 2>&1)

		# Vérifie si le pull a réussi
        if [[ "$output" == "Already up to date." ]]; then
            
			# Afficher $output en vert
			echo -e "\033[32m$output\033[0m\n"

		elif [[ -n "$output" ]]; then

			# Afficher $output en blanc
			echo "$output"

        else
            
			# Afficher un message d'échec
			echo -e "\033[31mÉchec du push pour $folder.\033[0m\n"

        fi

    else

		# Afficher un message d'érreur
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi

	cd $previous_location
}
