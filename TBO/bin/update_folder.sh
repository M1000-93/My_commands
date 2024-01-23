#!/bin/bash

# Inclure le script de vérification des réponses
. "$TBO_bin/verif_answer.sh"
# Inclure le chemin du script
. "$TBO_bin/path_tbo"
# Inclure le fichier de paramètres
. "$TBO_param"

# Fonction pour mettre à jour tous les dossiers
update_all_folders() {

	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " ]]; then
		for folder in "${github_folder[@]}"; do
    	    cd "$path_folder_github/$folder"
     	   	update_folder -g "$folder"
    	done
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}

# Fonction pour mettre à jour un dossier spécifique
update_selected_folder() {
    
	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " ]]; then
		if [[ $2 ]]; then
       		var_update_folder=$2
	    else
    	    echo -n "Quel est le nom du dossier que vous voulez mettre à jour ? "
        	read -r var_update_folder
	    fi

    	# Vérifier si le dossier existe déjà dans github_folder
    	if [[ -z "$var_update_folder" ]]; then
       		echo "\033[31mNom de dossier invalide. Opération annulée.\033[0m"
        	return
    	fi

    	# Vérifier si le dossier existe dans github_folder
	    if [[ "${github_folder[*]}" =~ "$var_update_folder"  ]]; then
	        update_folder -g "$var_update_folder" > /dev/null 2>&1
	        echo "\033[32mLe dossier a été mis à jour.\033[0m"
	    else
	        echo "\033[33mLe dossier $var_update_folder n'est pas présent dans la configuration.\033[0m"
	    fi
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}

# Fonction pour mettre à jour un dossier
update_folder() {
    local github=("-g" "-github")
    local intra=("-i" "-intra")
	local folder="$2"
	date=$(date "+%Y-%m-%d %H:%M:%S")  # Formatage de la date

	if [[ " ${github[@]} " =~ " $1 " ]]; then
		cd $path_folder_github/$folder
		echo "Pour le dossier $folder :"
		echo -n "	"
		git add . > /dev/null
	    git commit -m "Projet : $folder - Mise à jour du $date" > /dev/null
	    git push
	    pull_output=$(git pull)
	    if [[ "$pull_output" != *"Already up to date."* ]]; then
    	    echo "$pull_output"
    	else
    	    echo -e "\033[32m$pull_output\033[0m"
    	fi
		cd "$previous_location"
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}
