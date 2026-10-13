#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"
PROJECT_NAME=""

PS3='Select feature to use: '
features=("Deploy" "Run" "Archive" "Exit")
select ftr in "${features[@]}"; do
	case "$ftr" in
		"Deploy")
			echo "Deploy feature not up yet"
			break
			;;
		"Run")
			echo "Run feature not up yet"
			break
			;;
		"Archive")
			echo "Archive feature not up yet"
			break
			;;
		"Exit")
			echo "Exiting Application"
			exit
			;;
		*) echo "Error: invalid input $REPLY, select within valid range 1-4";;
	esac
done
