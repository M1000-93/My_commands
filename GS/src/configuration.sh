#!/bin/bash

# Fonction pour configurer les variables utilisateur
variable_conf_usr() {
    
    # Inclusion des chemins d'accès à GS
    . ~/.GS/bin/path_gs

    # Inclusion du script de vérification des réponses
    . $GS_bin/tools_GS.sh

    local i=0
    local var_answer

    # Demander le login de l'utilisateur et le login GitHub
    read -rp "Quel est votre login ? (en minuscule) " var_login
    read -rp "Quel est le login de votre GitHub ? " var_github_login
    var_github_link="git@github.com:$var_github_login"
    
    # Demander à l'utilisateur s'il souhaite utiliser un répertoire pour cloner ses dossiers GitHub
    read -rp "Voulez-vous utiliser ce répertoire pour cloner vos dossiers GitHub ? " var_answer
    get_folder -g "$var_answer"  # Appel à la fonction pour récupérer le dossier GitHub
    add_folder -g  # Appel à la fonction pour ajouter le dossier GitHub

    # Demander à l'utilisateur s'il souhaite utiliser un répertoire pour cloner ses dossiers Intra
    read -rp "Voulez-vous utiliser ce répertoire pour cloner vos dossiers Intra ? " var_answer
    get_folder -i "$var_answer"  # Appel à la fonction pour récupérer le dossier Intra
    add_folder -i  # Appel à la fonction pour ajouter le dossier Intra

    write_to_param_file  # Appel à la fonction pour écrire dans le fichier de paramètres
}

# Fonction pour gérer la configuration
configuration() {
    
    # Inclusion des chemins d'accès à GS
    . ~/.GS/bin/path_gs

    # Inclusion du script de vérification des réponses
    . $GS_bin/tools_gs.sh

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
