#!/bin/bash

# Fonction pour écrire les variables dans le fichier de paramètres
write_to_param_file() {

	source ~/.GS/bin/path_gs

    # Écriture des variables dans le fichier de paramètres
    printf "#=============== LOGIN ==============\
	\n\nvar_login=\"%s\" \
	\n\n#=============== GITHUB ==============\
	\n\nvar_github_link=\"%s\" \
	\npath_folder_github=\"%s\" \
	\ngithub_folder=(%s)\
	\n\n#=============== INTRA ==============\
	\n\npath_folder_intra=\"%s\" \
	\nintra_folder=(%s)\
	\nvar_links_intra=(%s)\n"\
	 "$var_login" "$var_github_link" "$path_folder_github" "$(IFS=' '; echo "${github_folder[*]}")" "$path_folder_intra" "$(IFS=' '; echo "${intra_folder[*]}")" "$(IFS=' '; echo "${var_links_intra[*]}")" > "$GS_param"
    
    # Modification des permissions du fichier de paramètres
    chmod 777 "$GS_param"
    
    # Sourcing du fichier de paramètres pour mettre à jour les variables dans le script
    source "$GS_param"
}

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

# Fonction pour connecter l'utilisateur a l'Intra
intra_connection(){
	
	# Récupération de la page de connexion à l'Intra
	out=$(curl -s -c "$GS_data/cookie.out" -L "https://signin.intra.42.fr/users/sign_in")
	post_link=$(echo -e $out | sed -E -e "s/>/\n/g" | grep "action=" | sed -E -e "s/ /\n/g" | grep "action=" | cut -c 8- | sed -E -e "s/\"//g")

	# Demande le login à l'utilisateur puis fait une mise à jour des variables dans log.txt
	echo -en "\nLogin        : \033[32m"
	read -e var_login || write_to_param_file
	echo -en "\033[0m"

	# Demande le mot de passe de l'utilisateur en remplaçant les caractères par des "*" et en terminant par un \n
	echo -en "Password     : \033[33m"
	while IFS= read -r -s -n 1 char; do
	    if [[ -z $char ]]; then
	        break
	    fi

		echo -n "*"
	    password+="$char"
	done
	echo -e "\033[0m\n"
	# Connecte l'utilisateur et sauvegarde ces cookies pour permettre la récupération des projets Intra
	curl -s -X POST -H "Content-Type: application/x-www-form-urlencoded" -b "$GS_data/cookie.out" -d "username=${var_login}&password=${password}" -c "$GS_data/cookie_sessions.out" -b "$GS_data/cookie.out" -L --max-redirs 2 -o /dev/null $post_link
}

# Fonction pour déplacer vers un dossier GitHub ou Intra
move_to() {
    
    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub
    if [[ " ${github[@]} " =~ " $1 " ]]; then
        
        # Demander à l'utilisateur s'il souhaite se déplacer vers un dossier GitHub
        echo -en "Voulez-vous vous déplacer dans votre dossier \033[33mGitHub ?\033[32m "
        read -r var_answer
        echo -en "\033[0m"  # Réinitialiser les couleurs de la console
        verif_answer "$var_answer"  # Appel à la fonction de vérification de la réponse

        # Vérifier si la réponse est négative
        if [[ "$?" == 0 ]]; then
            
            previous_location=$(pwd)  # Enregistrer l'emplacement précédent
			cd $path_folder_github  # Se déplacer vers le dossier GitHub

        fi

    # Vérifier si l'option spécifiée est Intra
    elif [[ " ${intra[@]} " =~ " $1 " ]]; then
        
        # Demander à l'utilisateur s'il souhaite se déplacer vers un dossier Intra
        echo -en "Voulez-vous vous déplacer dans votre dossier \033[33mIntra ?\033[32m "
        read -r var_answer
        echo -en "\033[0m"  # Réinitialiser les couleurs de la console
        verif_answer "$var_answer"  # Appel à la fonction de vérification de la réponse

        # Vérifier si la réponse est négative
        if [[ "$?" == 0 ]]; then
            
            previous_location=$(pwd)  # Enregistrer l'emplacement précédent
			cd $path_folder_intra  # Se déplacer vers le dossier Intra

        fi

    else
        # Afficher un message d'erreur si aucune option valide n'est spécifiée
        echo -e "\033[31mUne erreur est survenue !\033[0m"
    fi

}

# Fonction pour obtenir le chemin du répertoire à utiliser pour le clonage de dossiers GitHub ou Intra.
get_folder() {

	source "$GS_param"

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
            echo -ne "Quel repertoire voulez-vous utilisez ? \033[33m$HOME/"
            read -e -r path_github
			echo -en "\033[0m"
            if [[ -n "$path_github" ]]; then
                path_folder_github=$HOME/$path_github/
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
            echo -ne "Quel repertoire voulez-vous utilisez ? \033[33m$HOME/"
            read -e -r path_intra
			echo -en "\033[0m"
            if [[ -n "$path_intra" ]]; then
                path_folder_intra=$HOME/$path_intra/
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

# Fonction pour récupérer les projets depuis la page "https://projects.intra.42.fr/projects/list"
get_project () {
	# Récupération de la réponse de la page
	response=$(curl -s -b "$GS_data/cookie_sessions.out" -L "https://projects.intra.42.fr/projects/list")

    # Extraction des projets terminés
	n_line=$(echo "$response" | cat -n | grep ">finish" | awk '{print $1}')
	for i in $n_line; do
		# Extraction de la partie du HTML contenant le lien du projet
		rsp=$(echo "$response" | head -n $(($i + 6)) | tail -n 7 | grep "<a href=" | cut -c 24-)
		
		# Extraction de la partie après le guillemet pour obtenir le lien complet du projet
		rest=${rsp#*\"}
		
		# Extraction du nom du projet en coupant le début et la fin de la ligne
		# Tout en excluant les projets qui commencent par "c-piscine-" ou "exam-"
		project=$(echo $rsp | cut -c -$((${#rsp} - ${#rest} - 1)) | grep -v "c-piscine-" | grep -v "exam-")

        # Vérification et traitement du projet
		if [[ $project ]]; then
			
			# Récupération de l'URL du projet à partir de la page "https://projects.intra.42.fr/${project}/mine"
			repo=$(echo "$(curl -s -b "$GS_data/cookie_sessions.out" -L "https://projects.intra.42.fr/${project}/mine")" | grep "<input" | grep "git@" | cut -c 84- | sed -E -e "s/'>//g" | head -n 1)

			# Suppression du préfixe "42cursus-" du nom du projet, s'il est présent
			project=$(echo "$project" | sed -E 's/^42cursus-//')

            # Vérification si le projet n'est pas déjà dans le tableau
			if [[ ! " ${intra_folder[@]} " =~ " $project " ]]; then

				# Vérification si $intra_folder est vide
        		if [[ -z "${intra_folder[@]}" ]]; then

					# Si $intra_folder est vide
					intra_folder=($project)
					var_links_intra=($repo)
   				
				else

					# Si $intra_folder n'est pas vide
					intra_folder+=($project)
					var_links_intra+=($repo)

				fi
    		fi
		
			sleep 1
		fi
	done

    # Extraction des projets en cours
	n_line=$(echo "$response" | cat -n | grep "in progress" | awk '{print $1}')
	for i in $n_line; do
		# Extraction de la partie du HTML contenant le lien du projet
		rsp=$(echo "$response" | head -n $(($i + 6)) | tail -n 7 | grep "<a href=" | cut -c 24-)
		
		# Extraction de la partie après le guillemet pour obtenir le lien complet du projet
		rest=${rsp#*\"}
		
		# Extraction du nom du projet en coupant le début et la fin de la ligne
		# Tout en excluant les projets qui commencent par "c-piscine-" ou "exam-"
		project=$(echo $rsp | cut -c -$((${#rsp} - ${#rest} - 1)) | grep -v "c-piscine-" | grep -v "exam-")

        # Vérification et traitement du projet
		if [[ $project ]]; then
			
			# Récupération de l'URL du projet à partir de la page "https://projects.intra.42.fr/${project}/mine"
			repo=$(echo "$(curl -s -b "$GS_data/cookie_sessions.out" -L "https://projects.intra.42.fr/${project}/mine")" | grep "<input" | grep "git@" | cut -c 84- | sed -E -e "s/'>//g" | head -n 1)

			# Suppression du préfixe "42cursus-" du nom du projet, s'il est présent
			project=$(echo "$project" | sed -E 's/^42cursus-//')

            # Vérification si le projet n'est pas déjà dans le tableau
			if [[ ! " ${intra_folder[@]} " =~ " $project " ]]; then

				# Vérification si $intra_folder est vide
        		if [[ -z "${intra_folder[@]}" ]]; then

					# Si $intra_folder est vide
					intra_folder=($project)
					var_links_intra=($repo)
   				
				else

					# Si $intra_folder n'est pas vide
					intra_folder+=($project)
					var_links_intra+=($repo)

				fi
    		fi
		
			sleep 1
		fi
	done

    # Appel de la fonction write_to_param_file pour mettre à jour les tableaux
	write_to_param_file
}

# Fonction pour ajouter un dossier GitHub ou Intra
add_folder() {

	source "$GS_param"

    local github=("-g" "-github")  # Options pour les dossiers GitHub
    local intra=("-i" "-intra")     # Options pour les dossiers Intra

    # Vérifier si l'option spécifiée est GitHub ou si aucune option n'est spécifiée
    if [[ " ${github[@]} " =~ " $1 " || -z "$1" ]]; then
        
        # Boucle jusqu'à ce qu'une réponse valide soit obtenue
        while true; do
            
            # Demander à l'utilisateur s'il souhaite ajouter un dossier GitHub
            echo -en "Voulez-vous ajouter un dossier GitHub ? \033[33m(Yes/No)\033[0m "
            read -r var_answer
            verif_answer "$var_answer"  # Appel à la fonction de vérification de la réponse

            # Vérifier si la réponse est positive
            if [[ "$?" == 0 || -z "$var_answer" ]]; then
                
                echo -e "\033[33mAttention : les noms doivent être identiques à ceux de votre GitHub !\033[0m"
                echo -n "Quel est le nom du dossier ? "
                read -r  var_folder_name
                github_folder+=("$var_folder_name")  # Ajouter le nom du dossier à la liste des dossiers GitHub
                
            else
                write_to_param_file  # Appel à la fonction pour écrire dans le fichier de paramètres
                break  # Sortir de la boucle
            fi
        done
    # Vérifier si l'option spécifiée est Intra ou si aucune option n'est spécifiée
    elif [[ " ${intra[@]} " =~ " $1 " || -z "$1" ]]; then

		# Mise à jour et sourçage de log.txt pour intégrer les variables
		write_to_param_file

		# Vérifie si "cookie_sessions.out" existe ou pas
		if [[ ! -f "$GS_data/cookie_sessions.out" ]]; then

			# Connexion à l'Intra, sauvegarde du login puis récupération de "cookie_sessions.out"
			intra_connection

		fi

		# Récupération des projets Intra "finish" et "in progress" via les cookies enregistrés
		get_project

		# Vérification du résultat du processus de récupération
		if [ ${#intra_folder[@]} -ne ${#var_links_intra[@]} ]; then

			# Message indiquant une erreur dans le processus
			echo -e "\033[1m\033[31mErreur : Le nombre d'éléments dans intra_folder n'est pas égal au nombre d'éléments dans var_links_intra.\033[0m"

		else

			# Message de confirmation de bon déroulé de la récupération
			echo -e "\033[1m\033[32mNombre d'éléments dans les deux variables est : ${#intra_folder[@]}\033[0m"

		fi
		
		write_to_param_file
    
	else
        echo "\033[31mUne erreur est survenue !\033[0m"  # Afficher un message d'erreur si aucune option valide n'est spécifiée
    fi
}

verif_answer_result=$(verif_answer "$var_confirmation")