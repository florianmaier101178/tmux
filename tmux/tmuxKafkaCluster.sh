#!/bin/bash

SESSION="kafka-cluster"

function windowBeginningPart() {
    WINDOW_NAME=$1

    tmux new-window
    tmux rename-window $WINDOW_NAME
}

function windowEndingPart() {
    # remove unused first pane
    tmux kill-pane -t 0
}

function windowZookeeper() {
    WINDOW_NAME=zookeeper

    windowBeginningPart $WINDOW_NAME

    tmux split-window "rm -rf /tmp/kafka-logs-0 && rm -rf /tmp/kafka-logs-1 && rm -rf /tmp/kafka-logs-2 && rm -rf /tmp/zookeeper && zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties"

    windowEndingPart 
}

function windowKafkaBroker1() {
    WINDOW_NAME=kafka-broker-1

    windowBeginningPart $WINDOW_NAME

    tmux split-window "sleep 1 && kafka-server-start.sh /opt/kafka/config/server-0.properties"

    windowEndingPart 
}

function windowKafkaBroker2() {
    WINDOW_NAME=kafka-broker-2

    windowBeginningPart $WINDOW_NAME

    tmux split-window "sleep 2 && kafka-server-start.sh /opt/kafka/config/server-1.properties"

    windowEndingPart 
}

function windowKafkaBroker3() {
    WINDOW_NAME=kafka-broker-3

    windowBeginningPart $WINDOW_NAME

    tmux split-window "sleep 3 && kafka-server-start.sh /opt/kafka/config/server-2.properties"

    windowEndingPart 
}

# create a new detached session
tmux new -s $SESSION -d

windowZookeeper
windowKafkaBroker1
windowKafkaBroker2
windowKafkaBroker3

tmux select-window -t 0
tmux rename-window bash

# attach to the previously created session
tmux attach -d -t $SESSION

