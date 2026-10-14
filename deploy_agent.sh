#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"
PROJECT_NAME=""
PROJECT_DIR=""

preflight_check() {
	if command -v python3 &> /dev/null && command -v zip &> /dev/null; then
		echo "Programs python3 and zip are available"
	else
		echo "Error: make sure python3 and zip are downloaded"
		exit 1
	fi
}

project_naming() {
	read -p "Enter directory name" input
	dir="attendance_tracker_${input}"

	if [ -d "$dir" ]; then
		read -p "'$dir' directory already exist, would you like to overwrite it? (y/N): " response
		case "$response" in
		[yY][eE][sS]|[yY])
                	echo "Overwriting directory..."
                	rm -rf "$PROJECT_DIR"
                	;;
            	*)
                	echo "Operation cancelled."
                	exit 1
               		;;
        esac
    fi

    PROJECT_NAME="$input"
    PROJECT_DIR="$SCRIPT_DIR/attendance_tracker_${PROJECT_NAME}"
}

create_structure() {
    mkdir -p "$PROJECT_DIR/Helpers" "$PROJECT_DIR/reports"
    echo "Created project structure at $PROJECT_DIR"
}

deploy() {
	preflight_check
	project_naming
	create_structure

}

run() {
	echo "Not up yet"
}

archive() {
	echo "Not up yet"
}

PS3='Select feature to use: '
features=("Deploy" "Run" "Archive" "Exit")
select ftr in "${features[@]}"; do
	case "$ftr" in
		"Deploy")
			deploy
			break
			;;
		"Run")
			run
			break
			;;
		"Archive")
			archive
			break
			;;
		"Exit")
			echo "Exiting Application"
			exit 0
			;;
		*) echo "Error: invalid input $REPLY, select within valid range 1-4";;
	esac
done
