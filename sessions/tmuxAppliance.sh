#!/bin/bash

tmux new-session -s appliance -n git \; \
  send-keys 'appliance' C-m \; \
  send-keys C-l \; \
  new-window -n k8s \; \
  send-keys 'appliance' C-m \; \
  send-keys 'cd kubernetes' C-m \; \
  send-keys C-l \; \
  new-window -n db \; \
  send-keys C-l \; \
  send-keys 'echo db' \; \
  new-window -n docker \; \
  send-keys 'appliance' C-m \; \
  send-keys 'cd docker' C-m \; \
  send-keys C-l \; \
  new-window -n liquibase \; \
  send-keys 'appliance' C-m \; \
  send-keys 'cd dockerLiquibase' C-m \; \
  send-keys C-l \; \
  select-window -t 0 \;

