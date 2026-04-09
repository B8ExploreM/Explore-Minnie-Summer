#!/bin/bash
# This script helps users move through the Minnie Server project

# Colors
GREEN="\e[32m"
BLUE="\e[34m"
RESET="\e[0m"

usrPrompt() {
    local display_dir="${PWD/#$HOME/~}"
    printf "${GREEN}(Minnie)${BLUE} %s \$ ${RESET}" "$display_dir"
}

intro="Welcome to the Minnie Server, this project will help you gain experience with backend development."

find_helloproj="Let's begin by locating the hello project directory, use the command: cd hello_project/"

cmdERR="There was an issue with your command, check your spelling and try again."

promptUser() {
    read -e -p "$(usrPrompt)" prompt
}

function verifyCD() {
 verified="false"
 while [ "$verified" == "false" ]; do
        if [ "$prompt" == "cd hello_project/" ]; then
                eval $prompt
                if [ "$PWD" == "$expectedPWD" ]; then
                 echo "You have successfully moved into the hello project directory!"
                verified="true"

                else
                echo "$cmdERR"
                promptUser
                continue
                fi
        else
                echo "$cmdERR"
                promptUser
        fi
 done
}

function verifyPWD() {
        verified="false"
        while [ "$verified" == "false" ]; do
                if [ "$prompt" == "pwd" ]; then
                        verified="true"
                        eval $prompt
                else
                echo "$cmdERR"   
                promptUser   
                fi
        done            
}

function verifySetup() {
	echo "Checking Django project is present."
	verified="false"
	#test call here is represented by [] brackets
	if [ -d "hello_project" ]; then
		if [[ -f "hello_project/urls.py" && -f "hello_project/views.py" ]]; then
		verified="true"
		echo "Project found."
		else
			echo "Failed to find project files, please contact an administrator."
			echo "aborting"
			exit
		fi
	else
	echo "Failed to find project directory, please contact system administrator."
	exit
	fi
}

verifySetup

echo $intro
echo $find_helloproj
echo

promptUser
expectedPWD="${PWD}/hello_project"

verifyCD

echo "You should now be in the hello project folder, you can verify this by using the pwd command, try it now."
echo

promptUser
verifyPWD

echo
listDir="Now that we've verified we are in the right place, let's explore the files in this directory. Using \"ls -l\" take a look at the files in this directory, then use the command \"cat urls.py\" To print the contents of the file."
echo $listDir
promptUser

