#!/bin/bash

# Fonction pour configurer les variables utilisateur
variable_conf_usr() {
    
    # Inclusion des chemins d'accès à GS
    . ~/.GS/bin/path_gs

    # Inclusion du script de vérification des réponses
    . $GS_bin/tools_gs.sh

    local i=0
    local var_answer

	echo -en "Quel est le login de votre \033[33mGitHub\033[0m ? \033[32m"
	read -r var_github_login
	echo -en "\033[0m"
	var_github_link="git@github.com:$var_github_login"
    # Demander à l'utilisateur s'il souhaite utiliser un répertoire pour cloner ses dossiers GitHub
    echo -en "Voulez-vous utiliser ce répertoire pour cloner vos dossiers \033[33mGitHub\033[0m ? \033[33m(Yes/No)\033[32m "
	read -r var_answer
	echo -en "\033[0m"
    get_folder -g "$var_answer"  # Appel à la fonction pour récupérer le dossier GitHub
    add_folder -g  # Appel à la fonction pour ajouter le dossier GitHub

	# Demander à l'utilisateur s'il souhaite utiliser un répertoire pour cloner ses dossiers Intra
	echo -en "Voulez-vous utiliser ce répertoire pour cloner vos dossiers \033[33mIntra\033[0m ? \033[33m(Yes/No)\033[32m "
    read -r var_answer
	echo -en "\033[0m"
    get_folder -i "$var_answer"  # Appel à la fonction pour récupérer le dossier Intra
    
	echo "=============== Recuperation =============="
	add_folder -i  # Appel à la fonction pour ajouter le dossier Intra

    write_to_param_file  # Appel à la fonction pour écrire dans le fichier de paramètres
}

# Fonction pour gérer la configuration
configuration() {
    
    # Inclusion des chemins d'accès à GS
    GS=$(find ~/ -name GS -type d -exec sh -c 'find "$0" -type f -printf "%T@ %p\n" | sort -n | tail -1' {} \; | sort -n | tail -1 | cut -d ' ' -f 2-)
	if [[ -z $GS ]]; then
		echo -e "\033[1m\033[31mLa commande n'est pas presente !\033[0m"
	fi
	while [[ $GS != */GS ]]; do
		GS=$(dirname "$GS")
	done

	source $GS/bin/path_gs

    # Inclusion du script de vérification des réponses
    . $GS_bin/tools_gs.sh

    local var_answer

    # Demande à l'utilisateur s'il souhaite reconfigurer la commande
	echo "Il semble que vous ayez déjà configuré cette commande !"
	echo -en "Voulez-vous \033[31mreconfigurer\033[0m votre commande ? \033[33m(Yes/No)\033[32m "
    read -r var_answer
	echo -en "\033[0m"

    while true; do
        # Vérification de la réponse de l'utilisateur
        verif_answer "$var_answer"

        case $? in
            0)
                # Appel de la fonction pour configurer les variables utilisateur
                variable_conf_usr
                break
                ;;
            1)
                echo "Votre commande semble déjà configurée !"
                break
                ;;
            2)
                echo "Une erreur s'est produite !"
                break
                ;;
            *)
                echo "Une erreur inattendue s'est produite !"
                break
                ;;
        esac
    done
}

# Appel de la fonction de configuration
configuration
