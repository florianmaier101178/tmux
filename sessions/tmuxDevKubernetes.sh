#!/bin/bash

tmux new-session -s dev-k8s -n dev-k8s \; \
    send-keys 'clear && kubecfg current && kubecfg change haubusdevaks && kubecfg current' C-m \; \
    send-keys 'clear && kubecfg current && kubecfg change haubusdevaks && kubecfg current' \; \
    split-window -v -p 88 \; \
    send-keys C-l \; \
    send-keys 'kubectl ' \;

