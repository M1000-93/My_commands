#!/bin/bash
. /home/mechard/Downloads/.42_github/My_commands/all/y_or_n.sh

function configuration {

local	var_answer

echo "Il semble que vous avez configurer cette commande !"
echo "Voulez-vous reconfigurer votre commande ? (Y/N)"
read -r var_answer
while [[ "$var_answer" ]]; do
	verif_ans $var_answer
	if [[ "$var_global_ans" == "0" || "$var_global_ans" == "1" ]]; then
		break
	else
		echo "votre reponse doit etre \"Yes\" ou \"No\""
		read -r var_answer
	fi
done
if [[ "$var_global_ans" == "0" ]]; then
	variable_conf_usr
elif [[ "$var_global_ans" == "1" ]]; then
	echo "Votre commande semble configure !"
elif [[ "$var_global_ans" == "2" ]]; then
	echo "Une erreur c'est produite !"
fi

}