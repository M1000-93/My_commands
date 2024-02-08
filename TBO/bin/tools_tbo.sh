#!/bin/bash

# Fonction pour vérifier la réponse (Yes/No)
verif_answer() {
    # Récupérer la réponse passée en argument
    local response="$1"

    # Définir les réponses valides et invalides
    local valid_responses=("y" "Y" "yes" "Yes" "YES")
    local invalid_responses=("n" "N" "no" "No" "NO")

    # Vérifier si la réponse est dans les réponses valides ou est une chaîne vide
    for valid_response in "${valid_responses[@]}"; do
        if [[ "$response" == "$valid_response" || -z "$response" ]]; then
			return 0  # Réponse valide
        fi
    done

    # Vérifier si la réponse est dans les réponses invalides
    for invalid_response in "${invalid_responses[@]}"; do
        if [[ "$response" == "$invalid_response" ]]; then
			return 1  # Réponse invalide
        fi
    done

    return 2  # Réponse non reconnue
}

# Fonction pour écrire les variables dans le fichier de paramètres
write_to_param_file() {
    # Écriture des variables dans le fichier de paramètres
    printf "var_login=\"%s\"\nvar_github_link=\"%s\"\npath_folder_github=\"%s\"\ngithub_folder=(%s)\npath_folder_intra=\"%s\"\nintra_folder=(%s)\nvar_links_intra=(%s)\n" \
        "$var_login" "$var_github_link" "$path_folder_github" "$(IFS=' '; echo "${github_folder[*]}")" "$path_folder_intra" "$(IFS=' '; echo "${intra_folder[*]}")" \
        "$(IFS=' '; echo "${var_links_intra[*]}")" > "$TBO_param"
    
    # Modification des permissions du fichier de paramètres
    chmod 777 "$TBO_param"
    
    # Sourcing du fichier de paramètres pour mettre à jour les variables dans le script
    source "$TBO_param"
}

move_to() {

	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " ]]; then
		echo -en "Voulez-vous vous deplacer dans votre dossier \033[33mgithub ?\033[32m "
		read -r var_answer
		echo -en "\033[0m"
		verif_answer "$var_answer"
		if [[ "$?" == 0 ]]; then
			previous_location=$(pwd)
			cd $path_folder_github
		fi
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo -en "Voulez-vous vous deplacer dans votre dossier \033[33mintra ?\033[32m "
		read -r var_answer
		echo -en "\033[0m"
		verif_answer "$var_answer"
		if [[ "$?" == 0 ]]; then
			previous_location=$(pwd)
			cd $path_folder_intra
		fi
	else
		echo -e "\033[31mUne erreur est survenue !\033[0m"
	fi
}

# Fonction pour obtenir le chemin du répertoire à utiliser pour le clonage de dossiers GitHub ou Intra.
get_folder() {

    # Définition des options pour GitHub et Intra.
    local github=("-g" "-github")
    local intra=("-i" "-intra")

    # Définition des réponses valides et invalides pour la confirmation.
    local valid_responses=("y" "Y" "yes" "Yes" "YES")
    local invalid_responses=("n" "N" "no" "No" "NO")

    # Vérifier si l'argument GitHub ou Intra est vide ou non spécifié.
    if [[ (" ${intra[@]} " =~ " $1 " && -z $var_answer) || -z $1 ]]; then
        
		# Demander à l'utilisateur s'il veut utiliser le répertoire pour cloner des dossiers intra.
        echo -en "Voulez-vous utilisez ce repertoire pour cloner vos dossier \033[33mintra\033[0m ? \033[33m"
        read -r var_answer
        echo -en "\033[0m"

    elif [[ (" ${github[@]} " =~ " $1 " && -z $var_answer) || -z $1 ]]; then
        
		# Demander à l'utilisateur s'il veut utiliser le répertoire pour cloner des dossiers GitHub.
        echo -en "Voulez-vous utilisez ce repertoire pour cloner vos dossier \033[33mgithub\033[0m ? \033[33m"
        read -r var_answer
        echo -en "\033[0m"

    fi

    # Traitement des réponses de l'utilisateur en fonction du type (GitHub ou Intra) et de la validité.
    if [[ " ${valid_responses[@]} " =~ " $var_answer " && (" ${github[@]} " =~ " $1 "  || -z $1) ]]; then
        path_folder_github="$(pwd)/"
    elif [[ " ${valid_responses[@]} " =~ " $var_answer " && (" ${intra[@]} " =~ " $1 "  || -z $1) ]]; then
        path_folder_intra="$(pwd)/"
    elif [[ " ${invalid_responses[@]} " =~ " $var_answer " && (" ${github[@]} " =~ " $1 " || -z $1) ]]; then
        
		# Demander à l'utilisateur de spécifier un répertoire s'il a choisi "Non" pour GitHub.
        while [[  -z "$path_github"  ]]; do
			if [[ "$path_folder_github" ]]; then
				echo -e "Le repertoire \033[33mgithub\033[0m configure est \033[32m$path_folder_github\033[0m"
				echo -en "Voulez-vous le reconfiguer ? \033[32m"
				read -r var_answer
				echo -en "\033[0m"
				if [[ " ${invalid_responses[@]} " =~ " $var_answer " ]]; then
					echo "Le chemin n'as pas ete reconfigure !"
					return
				fi
			fi
            echo -ne "Quel repertoire voulez-vous utilisez ? \033[33m/home/$var_login/"
            read -r path_github
			echo -en "\033[0m"
            if [[ -n "$path_github" ]]; then
                path_folder_github=/home/$var_login/$path_github/
            else
                echo -e "\033[31mUne erreur est survenue ! Veuillez recommencer\033[0m"
            fi
        done

    elif [[ " ${invalid_responses[@]} " =~ " $var_answer " && (" ${intra[@]} " =~ " $1 " || -z $1) ]]; then
        
		# Demander à l'utilisateur de spécifier un répertoire s'il a choisi "Non" pour Intra.
        while [[ -z "$path_intra" ]]; do
			if [[ "$path_folder_intra" ]]; then
				echo -e "Le repertoire \033[33mintra\033[0m configure est \033[32m$path_folder_intra\033[0m"
				echo -en "Voulez-vous le reconfiguer ? \033[32m"
				read -r var_answer
				echo -en "\033[0m"
				if [[ " ${invalid_responses[@]} " =~ " $var_answer " ]]; then
					echo "Le chemin n'as pas ete reconfigure !"
					return
				fi
			fi
            echo -ne "Quel repertoire voulez-vous utilisez ? \033[33m/home/$var_login/"
            read -r path_intra
			echo -en "\033[0m"
            if [[ -n "$path_intra" ]]; then
                path_folder_intra=/home/$var_login/$path_intra/
            else
				echo -e "\033[31mUne erreur est survenue ! Veuillez recommencer\033[0m"
            fi
        done

    else

        # Afficher un message d'erreur en cas de réponse non reconnue ou incorrecte.
        echo -e "\033[31mUne erreur est survenue !\033[0m"
    
	fi

    # Afficher le chemin absolu du répertoire en fonction du type (GitHub ou Intra).
    if [[ " ${github[@]} " =~ " $1 " && "$path_folder_github" ]]; then
        echo -e "Le chemin absolu du repertoire sera : \033[32m$path_folder_github\033[0m"
    elif [[ " ${intra[@]} " =~ " $1 " && "$path_folder_intra" ]]; then
        echo -e "Le chemin absolu du repertoire sera : \033[32m$path_folder_intra\033[0m"
    fi

    # Demander à l'utilisateur de confirmer sa réponse.
    echo -en "Etes-vous sur de votre reponse ? \033[32m"
	read -r  var_confirmation
	echo -en "\033[0m"
    verif_answer "$var_confirmation"

    # Boucle pour demander à l'utilisateur de réessayer jusqu'à ce qu'une réponse valide soit fournie.
    while [[ "$?" == 1 ]]; do
        get_folder "$1" "$var_answer"
    done

    # Mettre à jour le fichier de configuration.
    write_to_param_file
}


add_folder() {

	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " || -z " $1 " ]]; then
		while true; do
        	echo -n "Voulez-vous ajouter un dossier GitHub ? \033[33m(Yes/No)\033[0m "
			read -r var_answer
    	    verif_answer "$var_answer"
    	    if [[ "$?" == 0 || -z "$var_answer" ]]; then
	            echo -e "\033[33mAttention : les noms doivent être identiques à ceux de votre GitHub !\033[0m"
				echo -n "Quel est le nom du dossier ? "
				read -r  var_folder_name
	            github_folder+=("$var_folder_name")
	        else
				write_to_param_file
	            break
	        fi
	    done
	elif [[ " ${intra[@]} " =~ " $1 " || -z " $1 " ]]; then
		while true; do
			echo -n "Voulez-vous ajouter un dossier intra ? \033[33m(Yes/No)\033[0m "
			read -r var_answer
    	    verif_answer "$var_answer"
    	    if [[ "$?" == 0 || -z "$var_answer" ]]; then
				echo -e "\033[33mAttention : les noms doivent être identiques à ceux de votre Intra !\033[0m"
        		echo -n "Quel est le nom du dossier ? "
				read -r  folder
				echo -ne "Quel est le lien intra du projet ? \033[33m(lien complet)\033[0m "
				read -r var_link

				# Vérification du format du lien
				prefix="git@vogsphere.42paris.fr:vogsphere/intra-uuid-"
				if [[ "$var_link" == "$prefix"*"$var_login" ]]; then
				    intra_folder=("${intra_folder[@]}" "$folder")
					var_links_folder=("${var_links_intra[@]}" "$var_link")
				else
				    echo "Le format du lien est invalide. Assurez-vous qu'il commence par '$prefix' et se termine par '$var_login'."
				fi

			else
				write_to_param_file
				break
			fi
	    done
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}

verif_answer_result=$(verif_answer "$var_confirmation")