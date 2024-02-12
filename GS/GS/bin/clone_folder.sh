#!/bin/bash

# Inclure les fichiers nécessaires
. $GS_bin/tools_gs.sh
. $GS_bin/path_gs
. $GS_param

# Fonction pour cloner tous les dossiers GitHub et Intra configurés
clone_all_folders() {
    
    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub ou Intra, ou si aucune option n'est spécifiée
    if [[ " ${github[@]} " =~ " $1 " || -z $1  ]]; then
        
		# Boucler à travers tous les dossiers GitHub et les cloner
        for folder in "${github_folder[@]}"; do

            clone_folder -g "$folder"  # Appel à la fonction clone_folder pour chaque dossier GitHub
		
		done
    elif [[ " ${intra[@]} " =~ " $1 " || -z $1  ]]; then
        # Boucler à travers tous les dossiers Intra et les cloner
        for folder in "${intra_folder[@]}"; do

            clone_folder -i "$folder"  # Appel à la fonction clone_folder pour chaque dossier Intra
        
		done
    else
	
		# Afficher un message d'échec
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}

# Fonction pour cloner un dossier avec choix
clone_selected_folder() {
    
    source "$GS_param"
    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub
    if [[ " ${github[@]} " =~ " $1 " ]]; then
        
		# Vérifier si un nom de dossier est fourni en argument
        if [[ $2 ]]; then
            var_add_folder=$2
        else

            # Demander à l'utilisateur le nom du dossier à cloner parmi ceux enregistrés
            echo "Voici les dossiers déjà enregistrés : \033[32m${github_folder[*]}\033[0m"
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
            echo -n "Voulez-vous le recréer ? (Yes/No) "
            read -r answer
            verif_answer "$answer"

            if [[ "$?" == 0 || -z "$answer" ]]; then

                # Supprimer le dossier existant et le recréer
                rm -rf "$var_add_folder" > /dev/null 2>&1

                clone_folder -g "$var_add_folder"  # Appel à la fonction clone_folder pour recréer le dossier
                
				# Afficher un message de réusssite
				echo -e "\033[32mLe dossier a été recréé.\033[0m"

            else

				# Afficher un message d'échec
                echo -e "\033[31mLe dossier n'a pas été recréé.\033[0m"

            fi
        else

            # Le dossier n'existe pas dans la configuration, ajoutons-le.
            add_folder_to_config -g "$var_add_folder"
			
            clone_folder -g "$var_add_folder"  # Appel à la fonction clone_folder pour cloner le nouveau dossier
        
		fi
    
	# Vérifier si l'option spécifiée est Intra
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		
		# Vérifier si un nom de dossier est fourni en argument
        if [[ $2 ]]; then
            var_add_folder=$2
        else

            # Demander à l'utilisateur le nom du dossier à cloner parmi ceux enregistrés
            echo -e "Voici les dossiers déjà enregistrés : \033[32m${intra_folder[*]}\033[0m"
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
            echo -n "Voulez-vous le recréer ? (Yes/No) "
            read -r answer
            verif_answer "$answer"

            if [[ "$?" == 0 || -z "$answer" ]]; then

                # Supprimer le dossier existant et le recréer
                rm -rf "$var_add_folder" > /dev/null 2>&1
                clone_folder -i "$var_add_folder"  # Appel à la fonction clone_folder pour cloner le nouveau dossier

				# Afficher un message de réusssite
                echo -e "\033[32mLe dossier a été recréé.\033[0m"

            else

				# Afficher un message d'échec
                echo -e "\033[31mLe dossier n'a pas été recréé.\033[0m"

            fi
        else

            # Le dossier n'existe pas dans la configuration, ajoutons-le.
            add_folder_to_config -i "$var_add_folder"

            clone_folder -i "$var_add_folder"  # Appel à la fonction clone_folder pour cloner le nouveau dossier
        
		fi
    else

		# Afficher un message d'échec
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}

# Fonction pour ajouter un dossier à la configuration
add_folder_to_config() {
    
    local folder="$2"
    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra
    local prefix="git@vogsphere.42paris.fr:vogsphere/intra-uuid-"

    # Vérifier si l'option spécifiée est GitHub
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

		# Afficher un message de réussite
        echo -e "\033[32mDossier ajouté avec succès !\033[0m"
    
    # Vérifier si l'option spécifiée est Intra
    elif [[ " ${intra[@]} " =~ " $1 " ]]; then
        
        # Demander à l'utilisateur le lien intra du projet
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

				# Afficher un message de réussite
                echo -e "\033[32mDossier ajouté avec succès !\033[0m"

            else

				# Afficher un message d'échec
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

				# Afficher un message de réussite
                echo -e "\033[32mDossier ajouté avec succès !\033[0m"

            else

				# Afficher un message d'échec
                echo "Le format du lien est invalide. Assurez-vous qu'il commence par '$prefix' et se termine par '$var_login'."

            fi
        fi
    else

		# Afficher un message d'échec
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi
}

# Fonction pour cloner un dossier GitHub ou Intra
clone_folder() {
    
    local folder="$2"
	local previous_location=$(pwd)

    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub
    if [[ " ${github[@]} " =~ " $1 " ]]; then

        echo -e "\033[33mClonage de $folder...\033[0m"
        git clone "$var_github_link/$folder.git" > /dev/null 2>&1

		# Vérifie si la commande git clone precédente a réussi
        if [ $? -eq 0 ]; then
            
			# Afficher un message de réussite
			echo -e "\033[32mClonage de $folder réussi.\033[0m"
			
        else

			# Afficher un message d'échec
            echo -e "\033[31mÉchec du clonage de $folder.\033[0m"

        fi
    # Vérifier si l'option spécifiée est Intra
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
			
			# Afficher un message de réussite
			echo -e "\033[32mClonage de $folder terminé avec succé !\033[0m"

        else
			# Afficher un message d'échec
            echo -e "\033[31mÉchec du clonage de $folder. L'indice n'a pas été trouvé.\033[0m"
        fi

		# Vérifie si la commande git clone precédente a réussi
        if [ $? -eq 0 ]; then
            
			# Afficher un message de réussite
			echo -e "\033[32mClonage de $folder réussi.\033[0m"

        else
            
			# Afficher un message d'échec
			echo -e "\033[31mÉchec du clonage de $folder.\033[0m"

        fi

    else

		# Afficher un message d'érreur
        echo "\033[31mUne erreur est survenue !\033[0m"

    fi

	cd $previous_location
}
