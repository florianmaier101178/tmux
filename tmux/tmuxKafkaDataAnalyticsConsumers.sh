#!/bin/bash

SESSION="kafka-dataanalytics"

function windowBeginningPart() {
    WINDOW_NAME=$1

    tmux new-window
    tmux rename-window $WINDOW_NAME
}

function windowEndingPart() {
    # remove unused first pane
    tmux kill-pane -t 0
}

function windowTopics() {
    WINDOW_NAME=topics

    windowBeginningPart $WINDOW_NAME

    tmux split-window 'bash --init-file <(\
        echo "echo list topics; \
        kafka-topics.sh --zookeeper 127.0.0.1:2181 --list; \
        kafka-topics.sh --create --topic data_analytics_telemetry --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic data_analytics_masterdata --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --describe --topic data_analytics_telemetry --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic data_analytics_masterdata --zookeeper 127.0.0.1:2181; \
    ")'

    windowEndingPart 
}

function windowConsumer() {
    WINDOW_NAME=consumers-1

    windowBeginningPart $WINDOW_NAME

    tmux split-window '
        sleep 10 && \
        echo "consuming data_analytics_telemetry" && \
        kafka-console-consumer.sh --topic data_analytics_telemetry --bootstrap-server localhost:9092 \
        '

    tmux split-window '
        sleep 10 && \
        echo "consuming data_analytics_masterdata" && \
        kafka-console-consumer.sh --topic data_analytics_masterdata --bootstrap-server localhost:9092 \
        '

    tmux select-layout even-vertical

    windowEndingPart
}

# create a new detached session
tmux new -s $SESSION -d

windowTopics
windowConsumer

# remove first window
tmux select-window -t 0
tmux kill-window -t 0

# focus topics window
tmux select-window -t topics

# attach to the previously created session
tmux attach -d -t $SESSION

