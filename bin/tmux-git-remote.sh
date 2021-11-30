#!/bin/bash

REPO_BASE_DIR="/home/flo/projects/cot"

CYAN='\033[1;36m'
NO_COLOR='\033[0m'

function header() {
    printf "${CYAN}GIT remote report - remote '$1' - for projects in '$REPO_BASE_DIR'${NO_COLOR}\n\n"
}

function repoHeader() {
    printf "repository: '${CYAN}$1${NO_COLOR}'\n"
    printf "\n"
}

function noChangesInRepository() {
    printf "neither 'remote' nor 'local' changes for origin: \n"
}

function loadRepoDirectories() {
    cd $REPO_BASE_DIR
    REPO_DIRS=( $(find . -mindepth 1 -maxdepth 1 -type d) )
}

function repositoriesRemoteCheck {
    header $1
    loadRepoDirectories

    for repo in ${REPO_DIRS[@]}
    do
        cd $REPO_BASE_DIR"${repo:1}"
        find . -mindepth 1 -maxdepth 1 -type d | grep --silent ".git"
        result=$?
        if [ $result -eq 0 ]; then
            repoHeader $repo
            remoteChanges=$(git log --oneline master..origin/master | wc -l)
            if [ $remoteChanges -ne 0 ]; then
                printf "${CYAN}$repo${NO_COLOR} has remote changes\n"
                printf "\n"
            fi

            localChanges=$(git log --oneline origin/master..master | wc -l)
            if [ $localChanges -ne 0 ]; then
                printf "${CYAN}$repo${NO_COLOR} has commits\n"
                git log -$commits
                printf "\n"
            fi

            if [ $remoteChanges -eq 0 ] && [ $localChanges -eq 0 ]; then
                noChangesInRepository $repo
                printf "\n"
            fi
        fi
    done
}

repositoriesRemoteCheck $1

read -p "Press enter ..."

