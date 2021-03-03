#!/bin/bash

SESSION="golang-project"

# check for project directory parameter
if [ "$#" -ne 1 ]; then
    echo "You have to provide a project directory"
    exit 1
fi

DIR=$1
DIR_GO_SRC="/usr/local/bin/go-src"

# verify that project directory is existing
if [ ! -d "$DIR" ]; then
    echo "'$DIR' is not existing, please create it first"
fi

function windowBeginningPart() {
    WINDOW_NAME=$1

    tmux new-window
    tmux rename-window $WINDOW_NAME
}

function windowEndingPart() {
    # remove unused first pane
    tmux kill-pane -t 0
}

function windowBash() {
    WINDOW_NAME=bash

    windowBeginningPart $WINDOW_NAME

    tmux split-window -c $DIR 'bash'

    tmux split-window -v -c $DIR 'bash'

    tmux select-layout even-vertical

    windowEndingPart
}

function windowProject() {
    WINDOW_NAME=project

    windowBeginningPart $WINDOW_NAME

    tmux split-window -c $DIR 'bash'
    
    tmux split-window -h -c "$DIR_GO_SRC/src" 'bash'

    tmux split-window -v -c $DIR 'bash'

    windowEndingPart
}

# create a new detached session
tmux new -s $SESSION -d

windowBash
windowProject

# remove first window
tmux select-window -t 0                                                                                 
tmux kill-window -t 0
    
# focus topics window 
tmux select-window -t project
tmux select-pane -t 2
tmux resize-pane -D 100
tmux select-pane -t 0

# attach to the created session
tmux attach -d -t $SESSION

