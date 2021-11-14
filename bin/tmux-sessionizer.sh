#!/bin/bash

selected=$(find . -mindepth 1 -maxdepth 1 -type d | fzf)

selected_name=$(basename $selected)
selected_dir=$(dirname $selected)/$selected_name
tmux_running=$(pgrep tmux)
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected_dir
    exit 0
fi

if ! tmux has-session -t $selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected_dir
fi

if [[ -z $TMUX ]]; then
    tmux attach-session -t $selected_name
else
    tmux switch-client -t $selected_name
fi
