#!/bin/bash

. $TBO_bin/verif_answer.sh
. $TBO_bin/path_tbo
. $TBO_param

delete_all_folders() {
    
	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " ]]; then
		for folder in "${github_folder[@]}"; do
    	   	delete_folder -g "$folder"
    	done
    	github_folder=()  # Réinitialise la variable github_folder
		write_to_param_file
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}

# Fonction pour supprimer un dossier avec choix
delete_selected_folder() {
    
	local github=("-g" "-github")
    local intra=("-i" "-intra")
	source "$HOME/Documents/42_Paris/Others/My_commands/TBO/data/conf"

	if [[ " ${github[@]} " =~ " $1 " ]]; then
    	if [[ $2 ]]; then
    	    var_delete_folder=$2
	    else
	        echo -n "Quel est le nom du dossier que vous voulez supprimer ? "
	        read -r var_delete_folder
	    fi

		# Vérifier si le dossier existe déjà dans github_folder
	    if [[ -z "$var_delete_folder" ]]; then
	        echo "\033[31mNom de dossier invalide. Opération annulée.\033[0m"
	        return
	    fi

	    # Vérifier si le dossier existe dans github_folder
	    if [[ "${github_folder[*]}" =~ "$var_delete_folder"  ]]; then
	        echo -ne "\033[33mVoulez-vous vraiment supprimer le dossier $var_delete_folder ? (Yes/No)\033[0m "
	        read -r answer
	        verif_answer "$answer"

	        if [[ "$?" == 0 || -z "$answer" ]]; then
	            delete_folder -g "$var_delete_folder" > /dev/null 2>&1
	            delete_folder_from_config -g "$var_delete_folder"
	            echo "\033[32mLe dossier a été supprimé avec succès.\033[0m"
	        else
	            echo "\033[31mLe dossier n'a pas été supprimé.\033[0m"
	        fi
	    else
	        echo "\033[33mLe dossier $var_delete_folder n'est pas présent dans la configuration.\033[0m"
	    fi
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}

delete_folder_from_config() {
	
	local folder="$2"
	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " ]]; then
		# Si folder correspond au premier élément de la liste github_folder
    	local new_github_folder=()
	    for item in "${github_folder[@]}"; do
	        [[ "$item" != "$folder" ]] && new_github_folder+=("$item")
	    done

	    # Mettre à jour le fichier de configuration
	    github_folder=("${new_github_folder[@]}")
	    write_to_param_file
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}

delete_folder() {
	
	local folder="$2"
	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " ]]; then
		echo "\033[33mSuppression du dossier $folder...\033[0m"
    	rm -rf "$folder"
		if [ $? -eq 0 ]; then
    	    echo -e "\033[32mSuppression de $folder réussi.\033[0m"
    	else
    	    echo -e "\033[31mÉchec de la suppression de $folder.\033[0m"
    	fi
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}