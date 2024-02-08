# _script_completion_tbo()
# {
#     cur="${COMP_WORDS[COMP_CWORD]}"
#     prev1="${COMP_WORDS[COMP_CWORD-1]}"
#     prev2="${COMP_WORDS[COMP_CWORD-2]}"
#     prev3="${COMP_WORDS[COMP_CWORD-3]}"

#     opts_first='-c -g -i -p -f -m'

# 	opts_second_folder='-u -update -cl -clone -p -push -a -add -d -del -delete -m -mv -move'
# 	opts_second_conf="-i -intra -g --github"

# 	opts_third="-a -all -c -choose"

# 	flag_with_conf="-move -mv -m -path -p -folder -f"
# 	flag_with_folder="-i -intra -g --github"

# 	case ${COMP_CWORD} in
# 		1)
# 			COMPREPLY=($(compgen -W "$opts_first" -- ${cur}))
# 		    ;;
#         2)
#             case ${prev1} in
#                 --configuration | -c )
#                     ;;
# 				--move | --mv | -m )
#                     echo -e "--update | -u : Update\n--clone | -cl : Clone\n--path | -p : Path\n--folder | -f : Folder"
#                     COMPREPLY=($(compgen -W "$opts_second_conf" -- ${cur}))
#                     ;;
# 				--path | -p )
#                     echo -e "--update | -u : Update\n--intra | -i : Intra\n--github | -g : GitHub"
#                     COMPREPLY=($(compgen -W "$opts_second_conf" -- ${cur}))
#                     ;;
# 				--folder | -f )
#                     echo -e "--update | -u : Update\n--intra | -i : Intra\n--github | -g : GitHub"
#                     COMPREPLY=($(compgen -W "$opts_second_conf" -- ${cur}))
#                     ;;
#                 --github | -g )
#                     echo -e "--update | -u : Update\n--clone | -cl : Clone\n--push | -p : Push\n--add | -a : Add\n--delete | -d : Delete\n--move | -m : Move"
#                     COMPREPLY=($(compgen -W "$opts_second_folder" -- ${cur}))
#                     ;;
#                 --intra | -i )
#                     echo -e "--update | -u : Update\n--clone | -cl : Clone\n--push | -p : Push\n--add | -a : Add\n--delete | -d : Delete\n--move | -m : Move"
#                     COMPREPLY=($(compgen -W "$opts_second_folder" -- ${cur}))
#                     ;;
#             esac
#             ;;
#         3)
# 			if [[ " ${flag_with_folder[@]} " =~ " ${prev2} " ]]; then
# 				case ${prev1} in
# 					--update | -u | --clone | -cl | --path | -p | --push | -p | --add | -a | --delete | -d | --move | -m )
#                         echo -e "--all | -a : All\n--choose | -c : Choose"
#                         COMPREPLY=($(compgen -W "$opts_third" -- ${cur}))
#                     	;;
#             	esac
# 			fi
#     esac
# }
# 
# complete -F _script_completion_tbo -o default -o nospace tbo

_script_completion_tbo(){
	local tc="/home/mechard/.TBO/TBO_command/tbo_completion"

	echo -e "-Bonjour\n"
	./"$tc" > /tmp/tbo_completion_output 2>&1
	cat /tmp/tbo_completion_output  # Afficher le contenu du fichier de sortie pour le débogage
}

complete -F _script_completion_tbo tbo
