#!/bin/bash

tmux new-session -s int-k8s -n int-k8s \; \
    send-keys 'clear && kubecfg current && kubecfg change haubusintegaks && kubecfg current' C-m \; \
    send-keys 'clear && kubecfg current && kubecfg change haubusintegaks && kubecfg current' \; \
    split-window -v -p 88 \; \
    send-keys C-l \; \
    send-keys 'kubectl ' \;

