#!/bin/bash

# Obtenir la résolution de l'écran actuelle
screen_info=$(xrandr --current | grep '*' | awk '{print $1}')

# Extraire la largeur et la hauteur de la résolution
screen_width=$(echo $screen_info | cut -d 'x' -f 1)
screen_height=$(echo $screen_info | cut -d 'x' -f 2)

# Boîte de dialogue pour choisir l'image GIF
choice=$(zenity --list --title="Lock select" --column="gifs" \
	"Smoking" \
    "Manger" \
	"Star !" \
	"R2D2" \
	"Colored stars" \
    "One piece" \
    "Star Wars" \
    "Vi" \
    "Wand" \
    --width=300 --height=200)

# Vérifier si l'utilisateur a fait un choix
if [ "$screen_info" == "1920x1080" ]; then
	if [ -n "$choice" ]; then
	    # Exécuter la commande en fonction du choix de l'utilisateur
	    case "$choice" in
	        "One piece")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Hat_Luffy.gif' $((screen_width / 2 - 65)) $((screen_height / 2 - 5)) 130 130
	            ;;
	        "Smoking")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Smoke.gif' $((screen_width / 2 - 10)) $((screen_height / 2 + 9)) 135 135
	            ;;
    	    "Manger")
    	        /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Eat.gif' $((screen_width / 2 - 90)) $((screen_height / 2 - 25)) 180 180
    	        ;;
			"Star !")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Stars.gif' $((screen_width / 2 - 85)) $((screen_height / 2 - 30)) 170 170
	            ;;
			"Colored stars")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/stars-colors.gif' $((screen_width / 2 - 110)) $((screen_height / 2 - 25)) 220 220
	            ;;
	        "R2D2")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/R2D2.gif' $((screen_width / 2 - 65)) $((screen_height / 2 - 7)) 130 135
	            ;;
	        "Star Wars")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Star_Wars.gif' $((screen_width / 2 - 116)) $((screen_height / 2 - 75)) 230 230
	            ;;
	        "Vi")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Vi_LOL.gif' $((screen_width / 2 - 60)) $((screen_height / 2 - 10)) 130 135
	            ;;
	        "Wand")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Wand_Harry_Potter.gif' $((screen_width / 2 - 65)) $((screen_height / 2 - 15)) 130 135
	            ;;
	        *)
	            echo "Choix non valide."
	            ;;
    	esac
	else
    	echo "Aucun choix sélectionné."
	fi
else
	if [ -n "$choice" ]; then
	    # Exécuter la commande en fonction du choix de l'utilisateur
	    case "$choice" in
	        "One piece")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Hat_Luffy.gif' $((screen_width / 2 - 65)) $((screen_height / 2 + 10)) 130 130
	            ;;
	        "Smoking")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Smoke.gif' $((screen_width / 2 - 90 + 80)) $((screen_height / 2 + 9)) 180 180
	            ;;
    	    "Manger")
    	        /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Eat.gif' $((screen_width / 2 - 115)) $((screen_height / 2 - 31)) 240 240
    	        ;;
			"Star !")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Stars.gif' $((screen_width / 2 - 120)) $((screen_height / 2 - 40)) 230 230
	            ;;
			"Colored stars")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/stars-colors.gif' $((screen_width / 2 - 148)) $((screen_height / 2 - 10)) 298 298
	            ;;
	        "R2D2")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/R2D2.gif' $((screen_width / 2 - 75)) $((screen_height / 2 - 7)) 150 150
	            ;;
	        "Star Wars")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Star_Wars.gif' $((screen_width / 2 - 130)) $((screen_height / 2 - 70)) 260 260
	            ;;
	        "Vi")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Vi_LOL.gif' $((screen_width / 2 - 80)) $((screen_height / 2 - 20)) 170 175
	            ;;
	        "Wand")
	            /sgoinfre/goinfre/Perso/jmaia/Public/pimp_my_lock_v2/pimp_my_lock '/home/mechard/Pictures/.Pictures/Lock_screen/Wand_Harry_Potter.gif' $((screen_width / 2 - 80)) $((screen_height / 2 - 27)) 170 175
	            ;;
	        *)
	            echo "Choix non valide."
	            ;;
    	esac
	else
    	echo "Aucun choix sélectionné."
	fi
fi