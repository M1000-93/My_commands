#!/bin/bash

# Alias pour git_simple
alias gis="git_simple"
alias gsi="git_simple"
alias gisi="git_simple"
alias git-simple="git_simple"
alias gspl="git_simple"

# The Biggest One is my own commands

function git_simple {

    ######### VARIABLES NIVEAU 1 #########

    # Options de configuration
    local var_config=("-c" "-configuration")
    # Options pour les opérations GitHub
    local var_github=("-g" "-github")
    # Options pour les opérations Intra
    local var_intra=("-i" "-intra")
	# Options pour spécifier le chemin
	local var_path=("-p" "-path")
	# Options pour spécifier le dossier
	local var_folder=("-f" "-folder")

    ######### VARIABLES NIVEAU 2 #########

    ## GITHUB && INTRA ##
    # Options pour la mise à jour
    local var_push=("-u" "-update")
    # Options pour le clonage
    local var_clone=("-c" "-cl" "-clone")
    # Options pour le push
    local var_push=("-p" "-push")
    # Options pour l'ajout
    local var_add=("-a" "-add")
	# Options pour la suppression
	local var_del=("-d" "-del" "-delete")
	# Options pour le déplacement
	local var_move=("-m" "-mv" "-move")

    ######### VARIABLES NIVEAU 3 #########

    ## UPDATE && CLONE && PUSH ##
    # Options pour toutes les opérations
    local var_all=("-a" "-all")
    # Options pour le choix
    local var_choose=("-c" "-choose")

    ######### AUTRES VARIABLES #########

	local previous_location=""

    ## LOCAL ##
    # Chargement des fonctions auxiliaires
	source /home/mechard/.GS/bin/path_gs
	. $GS_bin/tools_gs.sh
	. $GS_bin/path_gs
	. $GS_bin/push_folder.sh
	. $GS_bin/clone_folder.sh
	. $GS_bin/delete_folder.sh
	. $GS_bin/pull_folder.sh

    ######### AVEC ARGUMENT #########
	
	# Verifie si le fichier data/conf existe
	if [[ -e $GS_param ]]; then
		
		# Source data/conf si il existe
		source "$GS_param"

	fi

    # Commande pour lancer le script de configuration
    if [[ -z $1 || " ${var_config[@]} " =~ " $1 " || ! -e $GS_param ]]; then
        
		# Exécute la configuration
        bash "$GS_config"

	# Commandes concernant les repo Intra et Github
    elif [[ " ${var_path[@]} " =~ " $1 " ]]; then

		# Demande et configure les répertoires GitHub et Intra
        if [[ -z "$2" ]]; then
            
			# Exécute le script de configuration des dossiers pour Github ET l'Intra
            get_folder

		# Demande et configure le répertoire GitHub
        elif [[ " ${var_github[@]} " =~ " $2 " ]]; then

			# Exécute le script de configuration des dossiers pour Github
            get_folder -g
		
		# Demande et configure le répertoire Intra
        elif [[ " ${var_intra[@]} " =~ " $2 " ]]; then

			# Exécute le script de configuration des dossiers pour l'Intra
            get_folder -i

		# Message d'erreur - Probleme variables path_folder
        else

            echo -e "\033[5;31mUne erreur est survenue !\033[0m"

        fi

	# Commandes concernant l'ajout un dossier
    elif [[ " ${var_folder[@]} " =~ " $1 " ]]; then

        # Ajoute les dossiers GitHub et Intra
		if [[ -z "$2" ]]; then

			# Exécute le script d'ajout' des dossiers pour Github ET l'Intra
            add_folder
		
		# Ajoute le dossier GitHub
        elif [[ " ${var_github[@]} " =~ " $2 " ]]; then

			# Exécute le script d'ajout' des dossiers pour Github
            add_folder -g
		
		# Ajoute le dossier Intra
        elif [[ " ${var_intra[@]} " =~ " $2 " ]]; then

			# Exécute le script d'ajout' des dossiers pour l'Intra
            add_folder -i
		
		# Message d'erreur - Probleme deuxieme flag !
        else
            echo "\033[31mUne erreur est survenue !\033[0m"
        fi
    
	# Commandes concernant les dossiers de Github
	elif [[ " ${var_github[@]} " =~ " $1 " ]]; then
        
		# Verifie si l'utilisateur est deja present dans le dossier Github
		if [[ ( "$path_folder_github" && "$path_folder_github" != "$(pwd)/" ) || " ${var_move[@]} " =~ " $2 " ]]; then
            
			# Deplacement vers Github ou l'Intra : cas Github
            move_to -g

        fi
		
		# Sauvegarde de la localisation precedente
		previous_location=$(pwd)
		
		# Commandes relatives a "git push"
        if [[ " ${var_push[@]} " =~ " $2 " ]]; then
            
			# Push de tout les dossiers Github enregistre
            if [[ " ${var_all[@]} " =~ " $3 " || -z "$3" ]]; then

				# Exécute le script de push de tout les dossiers Github
                push_all_folders -g
				return

			# Push d'un seul dossier Github pre-defini ou a definir
            elif [[ " ${var_choose[@]} " =~ " $3 " ]]; then

				# Push d'un seul dossier Github pre-defini
                if [[ $4 ]]; then

					# Exécute le script de push du dossier Github pre-defini
                    push_selected_folder -g $4
				
				# Push d'un seul dossier Github a definir
                elif [[ -z $4 ]]; then

					# Exécute le script de push du dossier Github a definir
                    push_selected_folder -g

                # Message d'erreur - Probleme : Choose Push Github !
        		else
            		echo "\033[31mUne erreur est survenue !\033[0m"
        		fi
			
			# Message d'erreur - Probleme : Push Github !
			else
            	echo "\033[31mUne erreur est survenue !\033[0m"
        	fi

			return

		# Commandes relatives a "git clone"
        elif [[ " ${var_clone[@]} " =~ " $2 " ]]; then

			# Clone de tout les dossiers Github enregistrer
            if [[ " ${var_all[@]} " =~ " $3 " ]]; then

				# Verifie si la variable github_folder n'est pas vide : cas variable vide
                if [[ -z $github_folder ]]; then

					# Affiche un message d'avertissement en cas de variable vide
                    echo -e "\033[33mAucun folder n'as ete enregistre !"
					echo "Veuillez utiliser la commande gs -g -cl -c, pour un cloner un nouveau fichier !"
				
				# Verifie si la variable github_folder n'est pas vide : cas variable non-vide
                else

                    # Exécute le script de clone de tous les dossiers GitHub
                    clone_all_folders -g

                fi
			
			# Clone d'un seul dossier Github pre-defini ou a definir
            elif [[ " ${var_choose[@]} " =~ " $3 " ]]; then
                
				# Clone d'un seul dossier Github pre-defini
				if [[ $4 ]]; then

					# Exécute le script de clone du dossier Github pre-defini
                    clone_selected_folder -g $4
				
				# Clone d'un seul dossier Github a definir
                elif [[ -z $4 ]]; then

					# Exécute le script de clone du dossier Github a definir
                    clone_selected_folder -g

				# Message d'erreur - Probleme : Choose Clone Github !
        		else
            		echo "\033[31mUne erreur est survenue !\033[0m"
        		fi
            # Message d'erreur - Probleme : Clone Github !
        	else
            	echo "\033[31mUne erreur est survenue !\033[0m"
        	fi
        
			return

		# Commandes relatives a la suppression des dossiers en local
		elif [[ " ${var_del[@]} " =~ " $2 " ]]; then

			# Del de tout les dossiers Github enregistrer
            if [[ " ${var_all[@]} " =~ " $3 " ]]; then
               
			    # Exécute le script de suppression de tout les dossiers GitHub
                delete_all_folders -g
			
			# Del d'un seul dossier Github pre-defini ou a definir
            elif [[ " ${var_choose[@]} " =~ " $3 " ]]; then
                
				# Del d'un seul dossier Github pre-defini
				if [[ $4 ]]; then
                    
					# Exécute le script de suppression du dossier GitHub pre-defini
                    delete_selected_folder -g $4

				# Del d'un seul dossier Github a definir
                elif [[ -z $4 ]]; then
                    
					# Exécute le script de suppression du dossier GitHub a definir
					delete_selected_folder -g

                # Message d'erreur - Probleme : Choose Delete Github !
        		else
            		echo "\033[31mUne erreur est survenue !\033[0m"
        		fi
            # Message d'erreur - Probleme : Delete Github !
        	else
            	echo "\033[31mUne erreur est survenue !\033[0m"
        	fi
		# Message d'erreur - Probleme : Github !
        else
        	echo "\033[31mUne erreur est survenue !\033[0m"
			return
        fi

	# Commandes concernant les dossiers de l'Intra
	elif [[ " ${var_intra[@]} " =~ " $1 " ]]; then

		# Verifie si l'utilisateur est deja present dans le dossier Intra
        if [[ ( "$path_folder_intra" && "$path_folder_intra" != "$(pwd)/" ) || " ${var_move[@]} " =~ " $2 " ]]; then
            
			# Exécute le script de deplacement vers le dossier Intra
            move_to -i

        fi

		# Sauvegarde de la localisation precedente
		previous_location=$(pwd)

		# Commandes relatives a "git push"
        if [[ " ${var_push[@]} " =~ " $2 " ]]; then

			# Push de tout les dossiers Intra enregistre
            if [[ " ${var_all[@]} " =~ " $3 " || -z "$3" ]]; then

				# Exécute le script de push de tout les dossiers Intra
                push_all_folders -i

			# Push d'un seul dossier Intra pre-defini ou a definir
            elif [[ " ${var_choose[@]} " =~ " $3 " ]]; then
                
				# Push d'un seul dossier Intra pre-defini
				if [[ $4 ]]; then

					# Exécute le script de push d'un seul dossier Intra pre-defini
                    push_selected_folder -i $4

				# Push d'un seul dossier Intra a definir
                elif [[ -z $4 ]]; then

					# Exécute le script de push d'un seul dossier Intra a definir
                    push_selected_folder -i

                # Message d'erreur - Probleme : Choose Push Intra !
				else
            		echo "\033[31mUne erreur est survenue !\033[0m"
        		fi

            # Message d'erreur - Probleme : Push Intra !
			else
            	echo "\033[31mUne erreur est survenue !\033[0m"
        	fi
        
			return

		# Commandes relatives a "git clone"
		elif [[ " ${var_clone[@]} " =~ " $2 " ]]; then

			# Clone de tout les dossiers Intra enregistre
            if [[ " ${var_all[@]} " =~ " $3 " ]]; then

				# Verifie si la variable intra_folder n'est pas vide : cas variable vide
                if [[ -z $intra_folder ]]; then

					# Affiche un message d'avertissement en cas de variable vide
                    echo "Aucun folder n'as ete enregistre ! Veuillez utiliser la commande gs -g -cl -c !"
                
				# Verifie si la variable intra_folder n'est pas vide : cas variable non-vide
				else

                    # Exécute le script de clone de tous les dossiers Intra
                    clone_all_folders -i

                fi

			# Clone d'un seul dossier Intra pre-defini ou a definir
            elif [[ " ${var_choose[@]} " =~ " $3 " ]]; then
                
				# Clone d'un seul dossier Intra pre-defini
				if [[ $4 ]]; then

                    # Exécute le script de clone 'un seul dossier Intra pre-defini
                    clone_selected_folder -i $4

				# Clone d'un seul dossier Intra a definir
                elif [[ -z $4 ]]; then

					# Exécute le script de clone 'un seul dossier Intra pre-defini
                    clone_selected_folder -i

                # Message d'erreur - Probleme : Choose Clone Intra !
        		else
            		echo "\033[31mUne erreur est survenue !\033[0m"
        		fi
            
			# Message d'erreur - Probleme : Clone Intra !
        	else
            	echo "\033[31mUne erreur est survenue !\033[0m"
        	fi
        
			return

		# Commandes relatives a la suppression des dossiers en local
		elif [[ " ${var_del[@]} " =~ " $2 " ]]; then

			# Del de tout les dossiers Intra enregistre
            if [[ " ${var_all[@]} " =~ " $3 " ]]; then
                # Supprime tous les dossiers Intra
                delete_all_folders -i

			# Del d'un seul dossier Intra pre-defini ou a definir
            elif [[ " ${var_choose[@]} " =~ " $3 " ]]; then

				# Del d'un seul dossier Intra pre-defini
                if [[ $4 ]]; then

                    # Supprime le dossier Intra sélectionné
                    delete_selected_folder -i $4

				# Del d'un seul dossier Intra a definir
                elif [[ -z $4 ]]; then
                    delete_selected_folder -i
                # Message d'erreur - Probleme : Choose Delete Intra !
        		else
            		echo "\033[31mUne erreur est survenue !\033[0m"
        		fi

			
			# Message d'erreur - Probleme : Delete Intra !
        	else
            	echo "\033[31mUne erreur est survenue !\033[0m"
        	fi
            
			return

        # Message d'erreur - Probleme : Intra !
        else
           	echo "\033[31mUne erreur est survenue !\033[0m"
			return
       	fi

	# Commandes concernant le deplacement de l'utilisateur
	elif [[  " ${var_move[@]} " =~ " $1 "  ]]; then

		# Deplacement vers Github ou l'Intra : cas Github
		if [[ " ${var_github[@]} " =~ " $2 " ]]; then
			
			# Exécute le script de deplacement vers le dossier Github
			move_to -g
			return

		# Deplacement vers Github ou l'Intra : cas Intra
		elif [[ " ${var_intra[@]} " =~ " $2 " ]]; then
		
			# Exécute le script de deplacement vers le dossier Intra
			move_to -i
			return
		
		# Message d'erreur - Probleme : Move !
        else
           	echo "\033[31mUne erreur est survenue !\033[0m"
			return
       	fi
   	
	# Message d'erreur - Probleme : Boucle principale !
    else
       	echo "\033[31mUne erreur est survenue !\033[0m"
    fi

	# Verifie si la variable $previous_location n'est pas vide
	if [[ -n "$previous_location" ]]; then

		# Si la variable n'est pas vide, deplace l'utilisateur vers sa localistion precedente
		cd "$previous_location"

	fi
}
