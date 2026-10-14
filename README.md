# deploy_agent_Eden-GNI

Summative Assignment

Construction of script shell:

Repository deploy_agent_created_Eden-GNI created.
Templates directory created and source files (attendance_checker.py, assets.cvs, and config.json) have been added to it.
deploy_agent.sh file has been created.
Interactive menu with least of feature: Deploy, Run, Archive, and Exit; has been scripted in the deploy_agent.sh file.
Added variable to allow script to have access to files withing the /templates directory.
Added preflight_check function to verify if python3 and zip are installed in terminal.
Added preject_naming function to prompt user on creating a directory as well as overwriting scenario.
Added create_structure function to create the structure of attendance tracker folder.
Created functions for deploy, run, archive, although for now only place holder inputs are in it.
updated interactive menu to run the funcions deploy, run, archive (although empty for now).
Copy commands to transport template files in new directories created from the shell script.
Option A and Option B have been implemented to the build_roster function.
Permissions for the files have been inputed as well as confirmation messages for each file.
Update_thresholds function added for confirmation of previous functions running properly.
Run function added to change directories to created directory and run 'attendance_checker.py' file with python3.
A handle_system function has been added for when the signals ctrl+c and ctrl+z are used.
When the signals are used during the deployment stage, a message will be sent to the user that the deployment was interrupted.
As well as checking if there is anything that needs to be archived before exiting cleanly.
