
function verif_ans {

	local var_validate_minus="y"
	local var_validate_maj="Y"
	local var_validate_complete_minus="yes"
	local var_validate_complete_maj="Yes"

	local var_invalidate_minus="n"
	local var_invalidate_maj="N"
	local var_invalidate_complete_minus="no"
	local var_invalidate_complete_maj="No"

	if [[ "$1" == "$var_validate_minus" || "$1" == "$var_validate_maj" ]]; then
		var_global_ans="0"
	elif [[ "$1" == "$var_validate_complete_minus" || "$1" == "$var_validate_complete_maj" ]]; then
		var_global_ans="0"
	elif [[ "$1" == "$var_invalidate_minus" || "$1" == "$var_invalidate_maj" ]]; then
		var_global_ans="1"
	elif [[ "$1" == "$var_invalidate_complete_minus" || "$1" == "$var_invalidate_complete_maj" ]]; then
		var_global_ans="1"
	else
		var_global_ans="2"
	fi
}