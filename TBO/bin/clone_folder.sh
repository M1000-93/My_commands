#!/bin/bash

. $TBO_bin/verif_answer.sh
. $TBO_bin/path_tbo
. $TBO_param

# Fonction pour cloner tous les dossiers GitHub configurés
clone_all_folders() {
    
	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " ]]; then
		for folder in "${github_folder[@]}"; do
	        clone_folder -g "$folder"
	    done
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}

# Fonction pour cloner un dossier avec choix
clone_selected_folder() {
    
	source "$HOME/Documents/42_Paris/Others/My_commands/TBO/data/conf"
	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " ]]; then
	    # Vérifier si un nom de dossier est fourni en argument
	    if [[ $2 ]]; then
	        var_add_folder=$2
	    else
	        # Demander à l'utilisateur le nom du dossier à cloner
			echo "Voici les dossiers deja enregistre : ${github_folder[*]}"
	        echo -n "Quel est le nom du dossier que vous voulez cloner ?"
	        read -r var_add_folder
	    fi

	    # Vérifier si le nom de dossier est valide
	    if [[ -z "$var_add_folder" ]]; then
	        echo "Nom de dossier invalide. Opération annulée."
	        return
	    fi

	    # Vérifier si le dossier existe déjà dans github_folder
	    if [[ "${github_folder[*]}" =~ "$var_add_folder"  ]]; then
	        echo "\033[33mLe dossier $var_add_folder est déjà présent dans la configuration.\033[0m"
	        echo -n "Voulez-vous le recloner ? (Yes/No) "
	        read -r answer
	        verif_answer "$answer"

	       if [[ "$?" == 0 || -z "$answer" ]]; then
	            rm -rf "$var_add_folder" > /dev/null 2>&1
	            clone_folder -g "$var_add_folder"
				echo -e "\033[32mLe dossier a été recloné.\033[0m"
	        else
	            echo -e "\033[31mLe dossier n'a pas été recloné.\033[0m"
	        fi
	    else
	        # Le dossier n'existe pas dans la configuration, ajoutons-le.
	        add_folder_to_config -g "$var_add_folder"
	        clone_folder -g "$var_add_folder"
	    fi
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi	
}

# Fonction pour ajouter un dossier à la configuration
add_folder_to_config() {
    
	local folder="$2"
	local github=("-g" "-github")
    local intra=("-i" "-intra")

    if [[ " ${github[@]} " =~ " $1 " ]]; then
		# Ajouter le dossier à github_folder
	    if [ "${#github_folder[@]}" -eq 0 ]; then
	        github_folder=("$folder")
   		else
	        github_folder=("${github_folder[@]}" "$folder")
	    fi

	    # Mettre à jour le fichier de configuration
	    write_to_param_file
    	echo -e "\033[32mDossier ajouté avec succès !\033[0m"
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}

# Fonction pour cloner un dossier GitHub
clone_folder() {
    
	local folder="$2"
	local github=("-g" "-github")
    local intra=("-i" "-intra")

    if [[ " ${github[@]} " =~ " $1 " ]]; then
		echo -e "\033[33mClonage de $folder...\033[0m"
	    git clone "$var_github_link/$folder.git" > /dev/null 2>&1
	    if [ $? -eq 0 ]; then
	        echo -e "\033[32mClonage de $folder réussi.\033[0m"
	    else
	        echo -e "\033[31mÉchec du clonage de $folder.\033[0m"
	    fi
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}
