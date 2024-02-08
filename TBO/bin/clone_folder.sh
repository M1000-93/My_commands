#!/bin/bash

. $TBO_bin/tools_tbo.sh
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
		for folder in "${intra_folder[@]}"; do
	        clone_folder -i "$folder"
	    done
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}

# Fonction pour cloner un dossier avec choix
clone_selected_folder() {
    
	source "$TBO/data/conf"
	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " ]]; then
	    # Vérifier si un nom de dossier est fourni en argument
	    if [[ $2 ]]; then
	        var_add_folder=$2
	    else
	        # Demander à l'utilisateur le nom du dossier à cloner
			echo "Voici les dossiers deja enregistre : \033[32m${github_folder[*]}\033[0m"
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
		 if [[ $2 ]]; then
	        var_add_folder=$2
	    else
	        # Demander à l'utilisateur le nom du dossier à cloner
			echo -e "Voici les dossiers deja enregistre : \033[32m${intra_folder[*]}\033[0m"
	        echo -n "Quel est le nom du dossier que vous voulez cloner ?"
	        read -r var_add_folder
	    fi

		# Vérifier si le nom de dossier est valide
	    if [[ -z "$var_add_folder" ]]; then
	        echo "Nom de dossier invalide. Opération annulée."
	        return
	    fi

		# Vérifier si le dossier existe déjà dans intra_folder
	    if [[ "${intra_folder[*]}" =~ "$var_add_folder"  ]]; then
	        echo "\033[33mLe dossier $var_add_folder est déjà présent dans la configuration.\033[0m"
	        echo -n "Voulez-vous le recloner ? (Yes/No) "
	        read -r answer
	        verif_answer "$answer"

			if [[ "$?" == 0 || -z "$answer" ]]; then
	            rm -rf "$var_add_folder" > /dev/null 2>&1
	            clone_folder -i "$var_add_folder"
				echo -e "\033[32mLe dossier a été recloné.\033[0m"
	        else
	            echo -e "\033[31mLe dossier n'a pas été recloné.\033[0m"
	        fi
	    else
	        # Le dossier n'existe pas dans la configuration, ajoutons-le.
	        add_folder_to_config -i "$var_add_folder"
	        clone_folder -i "$var_add_folder"
	    fi
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi	
}

# Fonction pour ajouter un dossier à la configuration
add_folder_to_config() {
    
	local folder="$2"
	local github=("-g" "-github")
    local intra=("-i" "-intra")
	local prefix="git@vogsphere.42paris.fr:vogsphere/intra-uuid-"

    if [[ " ${github[@]} " =~ " $1 " ]]; then
		
		# Ajouter le dossier à github_folder si github_folder est vide
	    if [ "${#github_folder[@]}" -eq 0 ]; then
	        github_folder=($folder)

		# Ajouter le dossier à github_folder si github_folder n'est pas vide
   		else
	        github_folder=(${github_folder[@]} $folder)
	    fi

	    # Mettre à jour le fichier de configuration
	    write_to_param_file
    	echo -e "\033[32mDossier ajouté avec succès !\033[0m"
	
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		
		echo -ne "Quel est le lien intra du projet ? \033[33m(lien complet)\033[0m "
		read -r var_link

		# Ajouter le dossier à intra_folder si intra_folder est vide
	    if [ "${#intra_folder[@]}" -eq 0 ]; then
			
			# Vérification du format du lien
			if [[ "$var_link" == "$prefix"*"$var_login" ]]; then
				intra_folder=("$folder")
				var_links_intra=("$var_link")

				# Mettre à jour le fichier de configuration
				write_to_param_file
				echo -e "\033[32mDossier ajouté avec succès !\033[0m"
			else
			    echo "Le format du lien est invalide. Assurez-vous qu'il commence par '$prefix' et se termine par '$var_login'."
			fi

		# Ajouter le dossier à intra_folder si intra_folder n'est pas vide
		else
			
			# Vérification du format du lien
			if [[ "$var_link" == "$prefix"*"$var_login" ]]; then
				intra_folder=("${intra_folder[@]}" "$folder")
			    var_links_intra=("${var_links_intra[@]}" "$var_link")

				# Mettre à jour le fichier de configuration
				write_to_param_file
				echo -e "\033[32mDossier ajouté avec succès !\033[0m"
			else
			    echo "Le format du lien est invalide. Assurez-vous qu'il commence par '$prefix' et se termine par '$var_login'."
			fi
	    fi
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
    	echo -e "\033[33mClonage de $folder...\033[0m"

    	# Trouver l'indice de l'élément dans le tableau intra
    	index=-1
    	for ((i=0; i<=${#intra_folder[@]}; i++)); do
     		if [[ "${intra_folder[$i]}" == "$2" ]]; then
				index=$i
	            break
	        fi
	    done

	    # Vérifier si l'indice a été trouvé
	    if [[ $index -ne -1 ]]; then
	        # Utiliser l'indice pour accéder au lien correspondant dans var_links_intra
	        git clone "${var_links_intra[$index]}" "$folder" > /dev/null 2>&1
	    else
	        echo -e "\033[31mÉchec du clonage de $folder. L'indice n'a pas été trouvé.\033[0m"
	    fi

	    if [ $? -eq 0 ]; then
	        echo -e "\033[32mClonage de $folder réussi.\033[0m"
	    else
	        echo -e "\033[31mÉchec du clonage de $folder.\033[0m"
	    fi

		else
			echo "\033[31mUne erreur est survenue !\033[0m"
		fi
}
