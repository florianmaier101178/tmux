#!/bin/bash

REPO_BASE_DIR="/home/flo/projects/cot"

CYAN='\033[1;36m'
NO_COLOR='\033[0m'

function header() {
    printf "${CYAN}GIT report - repositories with '$1' for projects in '$REPO_BASE_DIR'${NO_COLOR}\n\n"
}

function dirtyMessage() {
    dirty=$1

    if [ $dirty -eq "0" ]; then
        echo "no dirty repositories found in '$REPO_BASE_DIR'"
    fi
}

function loadRepoDirectories() {
    cd $REPO_BASE_DIR
    REPO_DIRS=( $(find . -mindepth 1 -maxdepth 1 -type d) )
}

function repositoriesWithChanges() {
    header "changes"
    local repositoriesWithChanges=0
    loadRepoDirectories

    for repo in ${REPO_DIRS[@]}
    do
        cd $REPO_BASE_DIR"${repo:1}"
        find . -mindepth 1 -maxdepth 1 -type d | grep --silent ".git"
        result=$?
        if [ $result -eq 0 ]; then
            dirty=$(git status --short | wc -l)
            if [ $dirty -ne 0 ]; then
                printf "${CYAN}$repo${NO_COLOR} is dirty\n"
                git status --short
                repositoriesWithChanges=1
                printf "\n"
            fi
        fi
    done

    dirtyMessage $repositoriesWithChanges
}

function repositoriesWithCommits() {
    header "commits"
    local repositoriesWithCommits=0
    loadRepoDirectories

    for repo in ${REPO_DIRS[@]}
    do
        cd $REPO_BASE_DIR"${repo:1}"
        find . -mindepth 1 -maxdepth 1 -type d | grep --silent ".git"
        result=$?
        if [ $result -eq 0 ]; then
            commits=$(git log --oneline origin/master..master | wc -l)
            if [ $commits -ne 0 ]; then
                printf "${CYAN}$repo${NO_COLOR} has commits\n"
                git log -$commits
                repositoriesWithCommits=1
                printf "\n"
            fi
        fi
    done

    dirtyMessage $repositoriesWithCommits
}

if [ "${1}" = "changes" ]; then
    repositoriesWithChanges
fi

if [ "${1}" = "commits" ]; then
    repositoriesWithCommits
fi

read -p "Press enter ..."

