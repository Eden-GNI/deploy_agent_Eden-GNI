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
	read -p "Enter directory name: " input
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

build_roster() {
    local project_dir="attendance_tracker_${PROJECT_NAME}"
    local roster="$project_dir/Helpers/assets.csv"
    local config="$project_dir/Helpers/config.json"
    local template="$SCRIPT_DIR/templates/assets.csv"
    local choice count total available

    echo "How do you want to build the roster?"
    select choice in "Copy from template" "Generate fresh roster"; do
        case "$REPLY" in
            1|2) break ;;
            *) echo "Invalid choice, enter 1 or 2." ;;
        esac
    done

        while true; do
        read -rp "How many students? " count
        [[ "$count" =~ ^[1-9][0-9]*$ ]] && break
        echo "Please enter a positive whole number."
    done

    if [ "$REPLY" -eq 1 ]; then
        available=$(( $(grep -c '' "$template") - 1 ))
        if [ "$count" -gt "$available" ]; then
            echo "Template only has $available students; using $available."
            count="$available"
        fi
        head -n $(( count + 1 )) "$template" > "$roster"
        total=5
    else
        local names=("Alice Johnson" "Bob Smith" "Carol White" "David Brown" "Emma Davis"
                     "Frank Miller" "Grace Wilson" "Henry Moore" "Ivy Taylor" "Jack Anderson"
                     "Karen Thomas" "Leo Jackson")
        local emails=("alice@example.com" "bob@example.com" "carol@example.com" "david@example.com"
                      "emma@example.com" "frank@example.com" "grace@example.com" "henry@example.com"
                      "ivy@example.com" "jack@example.com" "karen@example.com" "leo@example.com")

        if [ "$count" -gt "${#names[@]}" ]; then
            echo "Only ${#names[@]} sample students available; using ${#names[@]}."
            count="${#names[@]}"
        fi

        echo "Email,Names,Attendance Count,Absence Count" > "$roster"
        for (( i=0; i<count; i++ )); do
            echo "${emails[i]},${names[i]},0,0" >> "$roster"
        done
        total=1
    fi

    sed -i "s/\(\"total_sessions\": *\)[0-9]*/\1${total}/" "$config"

    echo "Roster built with $count students. total_sessions set to $total."
}

update_thresholds() {
    local config="$project_dir/Helpers/config.json"
    local answer warn fail

    read -p "Update alert thresholds? (y/n): " answer
    [[ "$answer" =~ ^[Yy] ]] || return 0

    read -p "New warning threshold (default 75): " warn
    read -p "New failure threshold (default 50): " fail

    if [[ ! "$warn" =~ ^[0-9]+$ || ! "$fail" =~ ^[0-9]+$ ]]; then
        echo "Invalid input: thresholds must be numbers. Keeping defaults."
        return 0
    fi

    sed -i -e "s/\(\"warning\": *\)[0-9]\+/\1$warn/" \
           -e "s/\(\"failure\": *\)[0-9]\+/\1$fail/" "$config"
    echo "Thresholds updated: warning=$warn, failure=$fail"
}
deploy() {
	preflight_check
	project_naming
	create_structure

	cp "$TEMPLATES_DIR/attendance_checker.py" "$PROJECT_DIR/"
	cp "$TEMPLATES_DIR/config.json" "$PROJECT_DIR/Helpers"

	build_roster

	chmod +x "$PROJECT_DIR/attendance_checker.py"
	chmod 600 "$PROJECT_DIR/Helpers/config.json"

	if [ -x "$PROJECT_DIR/attendance_checker.py" ]; then
	 echo "'attendance_checker.py' has execute permission"
	else
	 echo "Execution is not allowed on 'attendance_checker.py' file"
	fi

	if [ -f "$PROJECT_DIR/Helpers/config.json" ]; then
	  perms=$(stat -c "%a" "$PROJECT_DIR/Helpers/config.json")
	  if [ "$perms" = "600" ] || [ "$perms" = "0600" ]; then
	    echo "File 'config.json' permissions are exactly 600."
	  else
	    echo "File 'config.json' permissions are $perms, not 600!"
	  fi
	else
	 echo "Error: File does not exist."
	fi

	update_thresholds
	run
}

run() {
	read -p "Enter directory name: " input
	PROJECT_NAME="$input"
	dir="attendance_tracker_${input}"

	if [ -d "$dir" ]; then
		cd "$dir"
		python3 "attendance_checker.py"
	else
		echo "Directory '$dir' does not exist. Check if you have deployed the application."
		return 1
	fi
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
