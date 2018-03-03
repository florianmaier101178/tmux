#!/bin/bash

# backup .tmux.conf
if [ -f ~/.tmux.conf ]; then
    DATE=`date '+%Y-%m-%d_%H:%M:%S'`
    mv ~/.tmux.conf ~/.tmux.conf.$DATE
fi

# link .tmux.conf
ln -s ~/tmux/tmux.conf ~/.tmux.conf

