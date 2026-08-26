#!/bin/bash
# This script helps users move through the Minnie Server project


# Colors
GREEN="\e[32m"
BLUE="\e[34m"
RESET="\e[0m"


# --- Integration setup ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STUDENT="${USER:-$(whoami)}"
export TUTOR_STATE_FILE="${SCRIPT_DIR}/json-backend/brains.json"
export TUTOR_PROJECT_DIR="${SCRIPT_DIR}/hello_project"


# Start watcher.py in the background (output redirected so it doesn't interleave with prompts)
python3 "${SCRIPT_DIR}/watcher.py" --student "$STUDENT" > "${SCRIPT_DIR}/watcher.log" 2>&1 &
WATCHER_PID=$!
# Kill watcher when tutor exits
trap "kill $WATCHER_PID 2>/dev/null" EXIT


# Helper: record completed command to backend
record() {
    local cmd="$1"
    local exit_code="${2:-0}"
    python3 "${SCRIPT_DIR}/json-backend/backend.py" \
        --student "$STUDENT" --validate "$exit_code" --cmd "$cmd"
}
# ---


# --- Replay of previously validated commands ---
# Commands the student has already successfully run earlier in this session.
# Re-typing one of these at a later prompt just executes it again instead of
# tripping the "there was a problem" error.
PAST_VALID_CMDS=()

is_known_cmd() {
    local input="$1"
    local c
    for c in "${PAST_VALID_CMDS[@]}"; do
        if [[ "$input" == "$c" ]]; then
            return 0
        fi
    done
    return 1
}

replay_cmd() {
    eval $prompt
    local ec=$?
    record "$prompt" "$ec"
}
# ---


#This Script looks for exact matches for its string prompts to prevent malicious code from being injected.
#If modified for more lax prompting, ensure that strings are escaped properly.


usrPrompt() {
    local display_dir="${PWD/#$HOME/~}"
    printf "${GREEN}(Minnie)${BLUE} %s \$ ${RESET}" "$display_dir"
}

echo
intro=" -> Welcome to the Minnie Server, this project will help you gain experience with backend development and frontend basics."
find_helloproj="Let's begin by locating the hello project directory, use the command: \"cd hello_project/\""
cmdERR="There was an issue with your command, check your spelling and try again."


prompt_user() {
    read -e -p "$(usrPrompt)" prompt
    prompt="$(echo -n "$prompt" | xargs)"   # trims leading/trailing whitespace, collapses internal runs
}


function verifyCD() {
    verified="false"
    while [ "$verified" == "false" ]; do
        if [ "$prompt" == "cd hello_project/" ]; then
            eval $prompt
            last_status=$?
            if [ "$PWD" == "$expectedPWD" ]; then
                echo "You have successfully moved into the hello project directory!"
                record "$prompt" "$last_status"
                PAST_VALID_CMDS+=("$prompt")
                verified="true"
            else
                echo "$cmdERR"
                prompt_user
                continue
            fi
        elif is_known_cmd "$prompt"; then
            replay_cmd
            prompt_user
        else
            echo "$cmdERR"
            prompt_user
        fi
    done
}


function verifyPWD() {
    verified="false"
    while [ "$verified" == "false" ]; do
        if [ "$prompt" == "pwd" ]; then
            verified="true"
            eval $prompt
            record "$prompt" "$?"
            PAST_VALID_CMDS+=("$prompt")
        elif is_known_cmd "$prompt"; then
            replay_cmd
            prompt_user
        else
            echo "$cmdERR"
            prompt_user
        fi
    done
}


function verifyListDir() {
    verified="false"
    while [ "$verified" == "false" ]; do
        if [ "$prompt" == "ls -l" ]; then
            verified="true"
            eval $prompt
            record "$prompt" "$?"
            PAST_VALID_CMDS+=("$prompt")
        elif is_known_cmd "$prompt"; then
            replay_cmd
            prompt_user
        else
            echo "$cmdERR"
            prompt_user
        fi
    done
}


function verifyCatUrls() {
    verified="false"
    while [ "$verified" == "false" ]; do
        if [ "$prompt" == "cat urls.py" ]; then
            verified="true"
            eval $prompt
            record "$prompt" "$?"
            PAST_VALID_CMDS+=("$prompt")
        elif is_known_cmd "$prompt"; then
            replay_cmd
            prompt_user
        else
            echo "$cmdERR"
            prompt_user
        fi
    done
}


function verifyCatViews() {
    verified="false"
    while [ "$verified" == "false" ]; do
        if [ "$prompt" == "cat views.py" ]; then
            verified="true"
            eval $prompt
            record "$prompt" "$?"
            PAST_VALID_CMDS+=("$prompt")
        elif is_known_cmd "$prompt"; then
            replay_cmd
            prompt_user
        else
            echo "$cmdERR"
            prompt_user
        fi
    done
}

function verifyNanoUrls() {
    verified="false"
    while [ "$verified" == "false" ]; do
        if [ "$prompt" == "nano urls.py" ]; then
            eval $prompt
            verified="true"
            record "$prompt" "$?"
            PAST_VALID_CMDS+=("$prompt")
        elif is_known_cmd "$prompt"; then
            replay_cmd
            prompt_user
        else
            echo "$cmdERR"
            prompt_user
        fi
    done
}


function verifyNano() {
    echo "Waiting for you to save your changes to index.html..."
    verified="false"
    while [ "$verified" == "false" ]; do
        if [ "$prompt" == "nano templates/index.html" ]; then
            eval $prompt
            verified="true"
            record "$prompt" "$?"
            PAST_VALID_CMDS+=("$prompt")
            touch "${TUTOR_PROJECT_DIR}/../config/wsgi.py" 2>/dev/null
        elif is_known_cmd "$prompt"; then
            replay_cmd
            prompt_user
        else
            echo "$cmdERR"
            prompt_user
        fi
    done
}


function verifyWget() {
    verified="false"
    while [ "$verified" == "false" ]; do
        if [ "$prompt" == "wget -qO- http://localhost/deploy/" ]; then
            verified="true"
            eval $prompt
            record "$prompt" "$?"
            PAST_VALID_CMDS+=("$prompt")
        elif is_known_cmd "$prompt"; then
            replay_cmd
            prompt_user
        else
            echo "$cmdERR"
            prompt_user
        fi
    done
}

function verifyHistory() {
    verified="false"
    while [ "$verified" == "false" ]; do
        if [ "$prompt" == "history" ]; then
            verified="true"
            record "$prompt" "0"
            PAST_VALID_CMDS+=("$prompt")
            python3 "${SCRIPT_DIR}/json-backend/backend.py" --student "$STUDENT" --history
        elif is_known_cmd "$prompt"; then
            replay_cmd
            prompt_user
        else
            echo "$cmdERR"
            prompt_user
        fi
    done
}


echo $intro
echo $find_helloproj


expectedPWD="${SCRIPT_DIR}/hello_project"
prompt_user
verifyCD


echo "-> You should now be in the hello project folder, verify this by using the \"pwd\" command."
echo


prompt_user
verifyPWD


echo
echo "Let's explore the files in this directory."
echo "-> Using \"ls -l\" take a look at the files in this directory"


prompt_user
verifyListDir


echo
echo "-> Great job, now you can see the list of all the files in your working directory. Use \"cat urls.py\" to display the file."


prompt_user
verifyCatUrls


echo
echo "-> Now let's make a change of your own. Run \"nano urls.py\" to open the file and edit it."


prompt_user
verifyNanoUrls


echo
echo "-> Good work, now print the contents of your views.py file using 'cat<filename>'"


prompt_user
verifyCatViews


echo
echo "-> Now it's time to get ready to make some changes on your own, \"nano templates/index.html\" to open the nano text editor, then change the message in the view function."


prompt_user
verifyNano


echo
echo "-> Your file has been saved. Now let's confirm your change is live. That is a capital O not a zero "
echo "Run: wget -qO- http://localhost/deploy/"
echo
prompt_user
verifyWget


echo
echo "Congratulations! You have completed the Minnie backend development exercise."
echo "You successfully edited an HTML file and navigated the backend and reflected the changes using wget."
echo
echo "-> Run \"history\" to see all the commands you have run while in the tutor"
echo "* You can press Ctrl+C at any time to exit the tutor."
echo


prompt_user
verifyHistory


echo
echo "-> You can press Ctrl+C at any time to exit the tutor."


trap 'exit 0' SIGINT
while true; do
    sleep 1
done