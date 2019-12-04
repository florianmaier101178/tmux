#!/bin/bash

tmux new-session -s stable-k8s -n stable-k8s \; \
    send-keys 'clear && kubecfg current && kubecfg change haubusstableaks && kubecfg current' C-m \; \
    send-keys 'clear && kubecfg current && kubecfg change haubusstableaks && kubecfg current' \; \
    split-window -v -p 88 \; \
    send-keys C-l \; \
    send-keys 'kubectl ' \;

