#!/bin/bash

COT_BASE_DIR="/home/flo/projects/cot"

CYAN='\033[1;36m'
NO_COLOR='\033[0m'

printf "${CYAN}GIT status report for projects in '$COT_BASE_DIR'${NO_COLOR}\n\n"

cd $COT_BASE_DIR

directories=( $(find . -mindepth 1 -maxdepth 1 -type d) )
declare -i dirtyRepositories=0

for directory in ${directories[@]}
do
    cd $COT_BASE_DIR"${directory:1}"
    find . -mindepth 1 -maxdepth 1 -type d | grep --silent ".git"
    result=$?
    if [ $result -eq 0 ]; then
        dirty=$(git status --short | wc -l)
        if [ $dirty -ne 0 ]; then
            echo $directory is dirty
            dirtyRepositories=1
        fi
    fi
done

if [ $dirtyRepositories -eq "0" ]; then
    echo "no dirty repositories below '$COT_BASE_DIR' found"
fi

printf "\n"

read -p ""

