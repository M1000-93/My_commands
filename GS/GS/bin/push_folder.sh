#!/bin/bash

# Inclure les fichiers nécessaires
. $GS_bin/tools_gs.sh
. $GS_bin/path_gs
. $GS_param

# Fonction pour pousser tous les dossiers GitHub et Intra configurés vers leurs dépôts distants
push_all_folders() {
    
    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub ou Intra, ou si aucune option n'est spécifiée
    if [[ " ${github[@]} " =~ " $1 " || -z $1  ]]; then

        # Boucler à travers tous les dossiers GitHub et les pousser vers leurs dépôts distants
        for folder in "${github_folder[@]}"; do

            push_folder -g "$folder"  # Appel à la fonction push_folder pour chaque dossier GitHub
        
		done
    elif [[ " ${intra[@]} " =~ " $1 " || -z $1  ]]; then

        # Boucler à travers tous les dossiers Intra et les pousser vers leurs dépôts distants
        for folder in "${intra_folder[@]}"; do

            push_folder -i "$folder"  # Appel à la fonction push_folder pour chaque dossier Intra
        
		done
    else
	
		# Afficher un message d'échec
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}

# Fonction pour pousser un dossier spécifique vers son dépôt distant
push_selected_folder() {
    
    source "$GS_param"
    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub
    if [[ " ${github[@]} " =~ " $1 " ]]; then
        
		# Vérifier si un nom de dossier est fourni en argument
        if [[ $2 ]]; then
            var_push_folder=$2
        else

            # Demander à l'utilisateur le nom du dossier à pousser vers son dépôt distant parmi ceux enregistrés
            echo "Voici les dossiers déjà enregistrés : \033[32m${github_folder[*]}\033[0m"
            echo -n "Quel est le nom du dossier que vous voulez pousser vers son dépôt distant ?"
            read -r var_push_folder

        fi

        # Vérifier si le nom de dossier est valide
        if [[ -z "$var_push_folder" ]]; then
            echo "Nom de dossier invalide. Opération annulée."
            return
        fi

        # Vérifier si le dossier existe dans github_folder
        if [[ "${github_folder[*]}" =~ "$var_push_folder"  ]]; then

            # Pousser le dossier vers son dépôt distant
            push_folder -g "$var_push_folder"  # Appel à la fonction push_folder pour pousser le dossier vers son dépôt distant

        else

            # Afficher un message d'échec
            echo -e "\033[31mLe dossier n'existe pas dans la configuration.\033[0m"

        fi
    
	# Vérifier si l'option spécifiée est Intra
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		
		# Vérifier si un nom de dossier est fourni en argument
        if [[ $2 ]]; then
            var_push_folder=$2
        else

            # Demander à l'utilisateur le nom du dossier à pousser vers son dépôt distant parmi ceux enregistrés
            echo -e "Voici les dossiers déjà enregistrés : \033[32m${intra_folder[*]}\033[0m"
            echo -n "Quel est le nom du dossier que vous voulez pousser vers son dépôt distant ?"
            read -r var_push_folder
			
        fi

        # Vérifier si le nom de dossier est valide
        if [[ -z "$var_push_folder" ]]; then
            echo "Nom de dossier invalide. Opération annulée."
            return
        fi

        # Vérifier si le dossier existe dans intra_folder
        if [[ "${intra_folder[*]}" =~ "$var_push_folder"  ]]; then

            # Pousser le dossier vers son dépôt distant
            push_folder -i "$var_push_folder"  # Appel à la fonction push_folder pour pousser le dossier vers son dépôt distant

        else

            # Afficher un message d'échec
            echo -e "\033[31mLe dossier n'existe pas dans la configuration.\033[0m"

        fi
    else

		# Afficher un message d'échec
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}

# Fonction pour pousser un dossier GitHub ou Intra vers son dépôt distant
push_folder() {
    
    local folder="$2"
	local previous_location=$(pwd)

    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub
    if [[ " ${github[@]} " =~ " $1 " ]]; then

        echo -e "\033[33mPousser $folder vers son dépôt distant...\033[0m\n"
        cd "$path_folder_github/$folder" || return  # Se déplacer vers le dossier GitHub

		git add -A *

		output=$(git commit -m "PUSH_GS | Update of $folder - DATE : $(date)")
		if [[ "$output" == *"On branch main"* && "$output" == *"Your branch is up to date with 'origin/main'."* && "$output" == *"nothing to commit, working tree clean"* ]]; then
			echo -e "\033[32mYour branch is up to date with 'origin/main'."
		else

			# Récupérer la première et la dernière ligne
			first_line=$(echo "$output" | head -n 1)
			last_line=$(echo "$output" | tail -n 1)

			# Afficher les lignes avec la couleur souhaitée
			echo -e "\033[36m$first_line\n$last_line"

		fi

        # Pousser les modifications vers le dépôt distant
        git push origin main > /dev/null 2>&1

		# Vérifie si le push a réussi
        if [ $? -eq 0 ]; then
            
			# Afficher un message de réussite
			echo -e "\n\033[32mLe dossier a été poussé vers son dépôt distant avec succès.\033[0m"
			
        else

			# Afficher un message d'échec
            echo -e "\033[31mÉchec du push pour $folder.\033[0m"

        fi
    # Vérifier si l'option spécifiée est Intra
    elif [[ " ${intra[@]} " =~ " $1 " ]]; then
        echo -e "\033[33mPousser $folder vers son dépôt distant...\033[0m"

        # Se déplacer vers le dossier Intra
        cd "$path_folder_intra/$folder" || return  

		git add -A *

		output=$(git commit -m "PUSH_GS | Update of $folder - DATE : $(date)")
		if [[ "$output" == *"On branch main"* && "$output" == *"Your branch is up to date with 'origin/main'."* && "$output" == *"nothing to commit, working tree clean"* ]]; then
			echo -e "\033[32mYour branch is up to date with 'origin/main'."
		else

			# Récupérer la première et la dernière ligne
			first_line=$(echo "$output" | head -n 1)
			last_line=$(echo "$output" | tail -n 1)

			# Afficher les lignes avec la couleur souhaitée
			echo -e "\033[36m$first_line\n$last_line"

		fi

        # Pousser les modifications vers le dépôt distant
        git push origin main > /dev/null 2>&1

		# Vérifie si le push a réussi
        if [ $? -eq 0 ]; then
            
			# Afficher un message de réussite
			echo -e "\033[32mLe dossier a été poussé vers son dépôt distant avec succès.\033[0m"

        else
            
			# Afficher un message d'échec
			echo -e "\033[31mÉchec du push pour $folder.\033[0m"

        fi

    else

		# Afficher un message d'érreur
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi

	cd $previous_location
}
