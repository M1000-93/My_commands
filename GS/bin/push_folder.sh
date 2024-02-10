#!/bin/bash

# Inclure le script de vérification des réponses
. "$GS_bin/tools_gs.sh"
# Inclure le chemin du script
. "$GS_bin/path_gs"
# Inclure le fichier de paramètres
. "$GS_param"

# Fonction pour mettre à jour tous les dossiers
push_all_folders() {

	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " || -z $1 ]]; then
		for folder in "${github_folder[@]}"; do
    	    cd "$path_folder_github$folder"
     	   	push_folder -g "$folder"
    	done
	elif [[ " ${intra[@]} " =~ " $1 " || -z $1 ]]; then
		for folder in "${intra_folder[@]}"; do
    	    cd "$path_folder_intra$folder"
     	   	push_folder -i "$folder"
    	done
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}

# Fonction pour mettre à jour un dossier spécifique
push_selected_folder() {
    
	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " ]]; then
		if [[ $2 ]]; then
       		var_push_folder=$2
	    else
    	    echo -n "Quel est le nom du dossier que vous voulez mettre à jour ? "
        	read -r var_push_folder
	    fi

    	# Vérifier si le dossier existe déjà dans github_folder
    	if [[ -z "$var_push_folder" ]]; then
       		echo "\033[31mNom de dossier invalide. Opération annulée.\033[0m"
        	return
    	fi

    	# Vérifier si le dossier existe dans github_folder
	    if [[ "${github_folder[*]}" =~ "$var_push_folder"  ]]; then
	        push_folder -g "$var_push_folder" > /dev/null 2>&1
	        echo "\033[32mLe dossier a été mis à jour.\033[0m"
	    else
	        echo "\033[33mLe dossier $var_push_folder n'est pas présent dans la configuration.\033[0m"
	    fi
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		if [[ $2 ]]; then
       		var_push_folder=$2
	    else
    	    echo -n "Quel est le nom du dossier que vous voulez mettre à jour ? "
        	read -r var_push_folder
	    fi

		# Vérifier si le dossier existe déjà dans intra_folder
    	if [[ -z "$var_push_folder" ]]; then
       		echo "\033[31mNom de dossier invalide. Opération annulée.\033[0m"
        	return
    	fi

		# Vérifier si le dossier existe dans intra_folder
	    if [[ "${intra_folder[*]}" =~ "$var_push_folder"  ]]; then
			push_folder -i "$var_push_folder" > /dev/null 2>&1
	        echo "\033[32mLe dossier a été mis à jour.\033[0m"
	    else
	        echo "\033[33mLe dossier $var_push_folder n'est pas présent dans la configuration.\033[0m"
    	fi
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}

# Fonction pour mettre à jour un dossier
push_folder() {
    local github=("-g" "-github")
    local intra=("-i" "-intra")
	local folder="$2"
	date=$(date "+%Y-%m-%d %H:%M:%S")  # Formatage de la date
	previous_location="$(pwd)"

	if [[ " ${github[@]} " =~ " $1 " ]]; then
		cd $path_folder_github/$folder
		echo "Pour le dossier $folder :"
		git add * > /dev/null 2>&1
	    git commit -m "Projet : $folder - Mise à jour du $date" > /dev/null 2>&1
		push_output=$(git push 2>&1)
	    if [[ "$pull_output" != "Everything up-to-date" ]]; then
    	    echo "\033[33mUn push est en cours\033[0m"
			echo
			echo "$push_output"
			echo
			echo -e "\033[32mPush termine !\033[0m"
    	else
    	    echo -n "	"
			echo -e "\033[32mEverything up-to-date\033[0m"
    	fi
		cd "$previous_location"
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		cd $path_folder_intra/$folder
		echo "Pour le dossier $folder :"
		git add * > /dev/null 2>&1
	    git commit -m "Projet : $folder - Mise à jour du $date" > /dev/null 2>&1
		push_output=$(git push 2>&1)
	    if [[ "$pull_output" != "Everything up-to-date" ]]; then
    	    echo "\033[33mUn push est en cours\033[0m"
			echo
			echo "$push_output"
			echo
			echo -e "\033[32mPush termine !\033[0m"
    	else
    	    echo -n "	"
			echo -e "\033[32mEverything up-to-date\033[0m"
    	fi
		cd "$previous_location"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}
