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

Running the script shell

First, clone the github repository with the git clone command followed by the repository link and navigate with the cd command to the repository:

	git clone repository_link
	cd repo_folder

Now, in the repository folder, execute the file 'deploy_agent.sh'

	./deploy_agent.sh

After that, a menu with 4 options will appear, and you will be asked to choose which feature you would like to enter.
For this application, you will type "1", then the ENTER key to start with the deploy feauture as that is the order I have chosen.
After the script checks that zip and python3 are installed, it will prompt you to input to name a new directory: 
"attendance_tracker_{input}" where {input} will be what you wrote down as a name for the directory when prompted.
If the directory already exist, you can press y to overwrite or any other key to abort.
After that, you will have to options on how you want to build the roster:

	Copy from template
	Generate fresh roster

After that, the script prints a message that the file of attendance_checker.py gains the execute permission,
and the file config.json will the permissions 600 (owner read and write only)
Then you will be asked if you want to update the thresholds which are set at "warning: 75" and "failure: 50" by default.
Type "y" to update them or "n" to leave it as it is.
After that, script will take you to feature 2: run.
Here, you will be asked to enter the project name, which is just what you named the directory in the deployment stage.
Then, 'attendance_checker.py' file will run and you will be asked to mark which students are present and absent.
If the project doesn't exist, then you will recieve an error message.
Now for feature 3, the application must be required to be ran at least once so that there are logs that can be archived.
Once again in the repository directory, execute the file 'deploy_agent.sh'

	./deploy_agent.sh

and choose type '3' then the ENTER key, to choose option 3: archive.
Enter the project name you've been using the whole time.
The script will move any existing logs into its own archive folder with a timestamp in the filename
A confirmation message shows which logs were archived.
If a log does not exist (for example, nobody was absent), it is reported as skipped and the script continues without crashing.

In the case of pressing ctrl+c and ctrl+z during the deploy feature, the following will happen

	the script will print that the deployment was interrupted
	then it will zip whatever has been created so far into an archived folder
	Delete the unfinished project directory
	And exit with non zero status

If interruption happens prior to entering a project name, there is nothing to archive, the script says so and exits. 
The interrupt handling applies only during deployment.

The end
