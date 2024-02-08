#!/bin/bash


# Inclusion du script de vérification des réponses
. $TBO_bin/tools_tbo.sh

variable_conf_usr() {

    local i=0
    local var_answer

	source /home/mechard/.TBO/bin/path_tbo
    read -rp "Quel est votre login ? (en minuscule) " var_login
    read -rp "Quel est le login de votre GitHub ? " var_github_login
	var_github_link="git@github.com:$var_github_login"
	
	read -rp "Voulez-vous utilisez ce repertoire pour cloner vos dossier github ? " var_answer
	get_folder -g "$var_answer"
	add_folder -g
	
	read -rp "Voulez-vous utilisez ce repertoire pour cloner vos dossier intra ? " var_answer
	get_folder -i "$var_answer"
	add_folder -i

    write_to_param_file
}


# Fonction pour gérer la configuration
configuration() {
    local var_answer

    # Demande à l'utilisateur s'il souhaite reconfigurer la commande
    read -rp "Il semble que vous ayez déjà configuré cette commande ! Voulez-vous reconfigurer votre commande ? (Yes/No) " var_answer

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
