var_global_ans=""
var_folder_github=""

function variable_conf_usr {

	local	i=0
	local	var_answer

	# if test -z "$var_login"; then
	# 	echo "Quel est votre login ?"
	# 	echo "(en minuscule)"
	# 	read -r var_login
	# fi
	# if test -z "$var_github_link"; then
	# 	echo "Quel est le lien de votre github ?"
	# 	echo -e "(git@github.com: + votre login github sans \\)"
	# 	read -r var_github_link
	# fi
	echo "Voulez-vous ajouter un dossier Github ?"
	read -r var_answer
	verif_ans $var_answer
	while [[ "$var_global_ans" == "0" ]]; do
		echo "Attention : les nom doivent etre identique a ce de votre Github !"
		echo "Quel est le nom du dossier"
		read -r var_folder_name
		{var_folder_github[i]}="$var_folder_name"
		echo "${var_folder_github[$i]}"
		echo "Voulez-vous ajouter un dossier Github ?"
		read -r var_answer
		verif_ans $var_answer
		if [[ "$var_global_ans" == "0" ]]; then
			((i++))
		else
			break;
		fi
	done
	echo -e "var_login=\"$var_login\"
var_github_link=\"$var_github_link\"
var_folder_github_0=\"$var_folder_github\"
var_folder_github_1=\"$var_folder_github\"" > data/conf.sh
	chmod 777 data/conf.sh
}