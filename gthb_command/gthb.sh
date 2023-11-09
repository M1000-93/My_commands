#!/bin/bash

# Go in the folder for Github

function github {

	######VAR_GLOBAL#######

	local var_usr="mechard"

    #######VAR_LVL_1#######
    
	local var_move="-move"
    local var_push="-push"
    local var_clone="-clone"
	local var_update_github_cursus="-update"

    #######VAR_LVL_2#######
    
    #MOVE#

    local var_perso="-perso"
    local var_libft="-libft"

    #MANAGE_GIT#

    local var_web_github="-webgithub"
    local var_42_git="-42git"

    #LINK#

    local var_web_link="git@github.com:M1000-93"

	#######VAR_LVL_3#######

    ##PROJECT##

    #WEB#

    local var_project_piscine="Piscine_42"
    local var_project_stud="Cursus_42"
	local var_project_mc="My_commands"

    #42#

    local var_project_libft="git@vogsphere.42paris.fr:vogsphere/intra-uuid-d6358c9a-5f9c-427d-90e6-c097fef3c0cb-5288950-mechard"

    #######OTHER_VAR#######
    local date=$(date)

    #################AVEC_ARGUMENT#################
        
            #########MOVE#########
    if [[ "$1" == "$var_move" ]]; then														###############
		if [[ "$2" == "$var_42_git" ]]; then												#
			if [[ $3 ]]; then																#
				cd /home/$var_usr/Documents/$var_project_stud/$3							#
			elif [[ !$3 ]]; then															#
				cd /home/$var_usr/Documents													#	Project
			else																			#
				echo -e "\033[31mIt's seems have not currently clone this project !\033[0m"	#
				echo -e "\033[31mPlease check the option -clone\033[0m"						#
			fi																				###############
		elif [[ "$2" == "$var_web_github" ]]; then											#
			if [[ "$3" == "$var_perso" ]]; then												#
            	cd /home/$var_usr/Downloads/.42_github/$var_project_stud					#
        	elif [[ "$3" == "$var_libft" ]]; then											#
            	cd /home/$var_usr/Downloads/.42_github/$var_project_stud/Libft				#	Github
    		elif [[ "$3" == "$var_project_mc" || "$3" == "$var_project_piscine" ]]; then	#
				cd /home/$var_usr/Downloads/.42_github/$3									#
			else																			#
            	cd /home/$var_usr/Downloads/.42_github										#
        	fi																				#
		else																				###############
			cd /home/$var_usr/Documents
		fi
            #########PUSH#########
    elif [[ "$1" == "$var_push" ]]; then
        if [[ "$2" == "$var_web_github" ]]; then                    						###############
			if [[ "$3" == "$var_project_mc" || "$3" == "$var_project_stud" ]]; then			#
				local previous_location=$(pwd)												#
				cd /home/$var_usr/Downloads/.42_github/$3									#
				git add *																	#	Github
				git commit -m "update of $date" --quiet										#
				git push --quiet															#
				cd $previous_location														#
			elif [[ !$3 ]]; then															#
				local previous_location=$(pwd)												#
				cd /home/$var_usr/Downloads/.42_github/$var_project_stud					#
				git add *																	#
				git commit -m "update of $date" --quiet										#
				git push --quiet															#
				cd /home/$var_usr/Downloads/.42_github/$var_project_mc						#
				git add *																	#
				git commit -m "update of $date" --quiet										#
				git push --quiet															#
			elif [[ $3 ]]; then																#
				local previous_location=$(pwd)												#
				cd /home/$var_usr/Downloads/$3												#
				git add *																	#
				git commit -m "update of $date" --quiet										#
				git push --quiet															#
				cd $previous_location														#
			fi																				#
		elif [[ "$2" == "$var_42_git" ]]; then												###############
            if [[ $3 ]]; then																#
				local previous_location=$(pwd)												#
				cd /home/$var_usr/Documents/$var_project_stud/$3							#
				git add *																	#
            	git commit -m "update of $date"												#
            	git push																	#
				echo -e "\033[32mYour project was push\033[0m"								#
				cd $previous_location														#	Project
			elif [[ !$3 || "$3" == "-currentlocation" ]]; then								#
				git add *																	#
				git commit -m "update of $date"												#
				git push																	#
				echo -e "\033[32mYour project was push\033[0m"								#
			fi																				#
		else																				###############
            echo -e "\033[31mYou need an argument to push your project !\033[0m"			#	Error
        fi																					###############
            #########CLONE#########
    elif [[ "$1" == "$var_clone" ]]; then													###############
        if [[ "$2" == "$var_web_github" ]]; then											#
            cd /home/$var_usr/Downloads														#
			mkdir -pv .42_github															#
			cd .42_github																	#
            if [[ "$3" == "$var_project_piscine" ||  "$3" == "$var_project_mc" ]]; then		#
                if [[ "$3" == "$var_project_piscine" ]]; then								#
					git clone "$var_web_link/$var_project_piscine.git" $3					#
				elif [[ "$3" == "$var_project_piscine" ]]; then								#
					git clone "$var_web_link/$3.git"										#
				cd $3																		#
				fi																			#
				echo -e "\033[32mYour project was clone in the corresponding folder\033[0m"	#
			elif [[ "$3" == "$var_project_stud" ]]; then									#	Github
                git clone "$var_web_link/Stud.git" $var_project_stud						#
				cd $var_project_stud														#
				echo -e "\033[32mYour project was clone in the corresponding folder\033[0m"	#
			elif [[ "$3" == "-rm" ]]; then													#
				rm -rf !(My_commands)														#
				echo -e "\033[32mYour Github repository has been erase !\033[0m"			#
			elif [[ !$3 ]]; then															#
				git clone "$var_web_link/$var_project_mc.git"								#
				git clone "$var_web_link/$var_project_piscine.git" Piscine_42_2023			#
				git clone "$var_web_link/Stud.git" $var_project_stud						#
				echo -e "\033[32mProjects was clone in the corresponding folder\033[0m"		#
			fi																				#
		elif [[ "$2" == "$var_42_git" ]]; then												###############
			cd /home/$var_usr/Documents														#
			mkdir -pv $var_project_stud														#
			cd $var_project_stud															#
            if [[ "$3" == "Libft" ]]; then													#	Project
                git clone "$var_project_libft" Libft										#
				cd Libft																	#
			else																			###############
            	echo -e "\033[31mYou need an argument to push your project !\033[0m"		#	Error
			fi																				#
		fi																					###############
	elif [[ "$1" == "$var_update_github_cursus" ]]; then
		local previous_location=$(pwd)
		cd /home/$var_usr/Downloads/.42_github/$var_project_stud
		git add *
		git commit -m "update of $date" --quiet
		git push --quiet
		cd /home/$var_usr/Downloads/.42_github/$var_project_mc
		git add *
		git commit -m "update of $date" --quiet
		git push --quiet
		cd $previous_location
	###############ARGUMENT_INVALIDE###############
    else
        echo -e "\033[31mThe command github need a valid argument !\033[0m"
        echo -e 'Check the manual of github for more informations'
    fi
}