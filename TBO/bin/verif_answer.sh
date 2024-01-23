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
    printf "var_login=\"%s\"\nvar_github_link=\"%s\"\npath_folder_github=\"%s\"\ngithub_folder=(%s)\nvar_folder_intra=(%s)\nvar_links_intra=(%s)\n" \
        "$var_login" "$var_github_link" "$path_folder_github" "$(IFS=' '; echo "${github_folder[*]}")" "$(IFS=,; echo "${var_folder_intra[*]}")" \
        "$(IFS=,; echo "${var_links_intra[*]}")" > "$TBO_param"
    
    # Modification des permissions du fichier de paramètres
    chmod 777 "$TBO_param"
    
    # Sourcing du fichier de paramètres pour mettre à jour les variables dans le script
    source "$TBO_param"
}

move_to() {

	local github=("-g" "-github")
    local intra=("-i" "-intra")

	if [[ " ${github[@]} " =~ " $1 " ]]; then
		echo -n "Voulez-vous vous deplacer dans votre dossier github ? "
		read -r var_answer
		verif_answer "$var_answer"
		if [[ "$?" == 0 ]]; then
			previous_location=$(pwd)
			cd $path_folder_github
		fi
	elif [[ " ${intra[@]} " =~ " $1 " ]]; then
		echo "Flag non dev"
	else
		echo "\033[31mUne erreur est survenue !\033[0m"
	fi
}