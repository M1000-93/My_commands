_script_completion_github()
{
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev1="${COMP_WORDS[COMP_CWORD-1]}"
    prev2="${COMP_WORDS[COMP_CWORD-2]}"
    prev3="${COMP_WORDS[COMP_CWORD-3]}"

    opts_first="-move -push -clone -update"

    opts_second="-webgithub -42git"

	opts_third_move_web_github="-perso -libft My_commands Piscine_42_2023"
	opts_third_push_web_github="Cursus_42 My_commands"
    opts_third_clone_web_github="Piscine_42 Cursus_42 My_commands"
    opts_third_42_git="Libft"

    case ${COMP_CWORD} in
        1)
            COMPREPLY=($(compgen -W "$opts_first" -- ${cur}))
            ;;
        2)
            case ${prev1} in
                -move)
                    COMPREPLY=($(compgen -W "$opts_second" -- ${cur}))
                    ;;
                -push)
                    COMPREPLY=($(compgen -W "$opts_second" -- ${cur}))
                    ;;
                -clone)
                    COMPREPLY=($(compgen -W "$opts_second" -- ${cur}))
                    ;;
            esac
            ;;
        3)
			if [[ "${prev2}" == "-move" ]]; then
				case ${prev1} in
					-webgithub)
                    	COMPREPLY=($(compgen -W "$opts_third_move_web_github" -- ${cur}))
                    	;;
                	-42git)
                	    COMPREPLY=($(compgen -W "$opts_third_42_git" -- ${cur}))
                	    ;;
            	esac
			elif [[ "${prev2}" == "-push" ]]; then
            	case ${prev1} in
					-webgithub)
                    	COMPREPLY=($(compgen -W "$opts_third_push_web_github" -- ${cur}))
                    	;;
                	-42git)
                	    COMPREPLY=($(compgen -W "$opts_third_42_git -currentlocation" -- ${cur}))
                	    ;;
            	esac
			elif [[ "${prev2}" == "-clone" ]]; then
				case ${prev1} in
					-webgithub)
                    	COMPREPLY=($(compgen -W "$opts_third_clone_web_github -rm" -- ${cur}))
                    	;;
					-42git)
                	    COMPREPLY=($(compgen -W "$opts_third_42_git" -- ${cur}))
                	    ;;
				esac
			fi
    esac
}
complete -F _script_completion_github -o default github
