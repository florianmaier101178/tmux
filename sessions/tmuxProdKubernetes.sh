#!/bin/bash

tmux new-session -s prod-k8s -n prod-k8s \; \
    send-keys 'clear && kubecfg current && kubecfg change haubusprodaks && kubecfg current' C-m \; \
    send-keys 'clear && kubecfg current && kubecfg change haubusprodaks && kubecfg current' \; \
    split-window -v -p 88 \; \
    send-keys C-l \; \
    send-keys 'kubectl ' \;

