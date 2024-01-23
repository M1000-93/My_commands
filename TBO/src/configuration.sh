#!/bin/bash

# Inclusion du script de vérification des réponses
. $HOME/Documents/42_Paris/Others/My_commands/TBO/bin/verif_answer.sh

variable_conf_usr() {

    local i=0
    local var_answer
	source /home/mechard/Documents/42_Paris/Others/My_commands/TBO/bin/path_tbo

    read -rp "Quel est votre login ? (en minuscule) " var_login
    read -rp "Quel est le login de votre GitHub ? " var_github_login
	var_github_link="git@github.com:$var_github_login"
	read -rp "Voulez-vous utilisez ce repertoire pour cloner vos dossier github ? " var_answer
	verif_answer "$var_answer"
	if [[ "$?" == 1 ]]; then
		path_folder_github="$(pwd)/"
	fi
	while [[ "$?" == 0 ]]; do
		read -rp "Quel repertoire voulez-vous utilisez ? (le chemin absolu sans /home/$var_login/) " path_github
		path_folder_github=/home/$var_login/$path_github/
		echo "Le chemin absolu du repertoire sera : $path_folder_github"
		read -rp "Etes-vous sur de votre reponse ? " var_confirmation
		verif_answer "$var_confirmation"
		if [[ "$?" == 0 ]]; then
			break
		fi
	done
	while true; do
        read -rp "Voulez-vous ajouter un dossier GitHub ? (Yes/No) " var_answer
        verif_answer "$var_answer"
        if [[ "$?" == 0 || -z "$var_answer" ]]; then
            read -rp "Attention : les noms doivent être identiques à ceux de votre GitHub !\nQuel est le nom du dossier ? " var_folder_name
            github_folder+=("\"$var_folder_name\"")
            ((i++))
        else
            break
        fi
    done
	i=0
	while true; do
        read -rp "Voulez-vous ajouter un projet intra ? (Yes/No) " var_answer
        verif_answer "$var_answer"
        if [[ "$?" == 0 || -z "$var_answer" ]]; then
            read -rp "Attention : les noms des projets sont sensibles a la casse !\nQuel est le nom du dossier ? " var_folder_name
            var_folder_intra+=("$var_folder_name")
			read -rp "Quel est le lien intra du projet intra? " var_intra_link
            var_links_intra+=("$var_intra_link")
            ((i++))
        else
            break
        fi
    done

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
