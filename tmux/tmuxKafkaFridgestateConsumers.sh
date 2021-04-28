#!/bin/bash

SESSION="kafka-interpreter"

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
        kafka-topics.sh --create --topic alarmprofile --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic validate_alarmprofile --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.temperaturesensor --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.doorsensor --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.unassignedibottelemetry --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --describe --topic alarmprofile --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic validate_alarmprofile --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.temperaturesensor --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.doorsensor --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.unassignedibottelemetry --zookeeper 127.0.0.1:2181; \
    ")'

    windowEndingPart 
}

function windowFirstConsumers() {
    WINDOW_NAME=consumers-1

    windowBeginningPart $WINDOW_NAME

    tmux split-window '
        sleep 15 && \
        echo "consuming alarmprofile" && \
        kafka-console-consumer.sh --topic alarmprofile --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 15 && \
        echo "consuming validate_alarmprofile" && \
        kafka-console-consumer.sh --topic validate_alarmprofile --bootstrap-server localhost:9092 \
        '

    tmux select-layout even-vertical

    windowEndingPart
}

function windowSecondConsumers() {
    WINDOW_NAME=consumers-2

    windowBeginningPart $WINDOW_NAME

    tmux split-window '
        sleep 20 && \
        echo "consuming interpreter.temperaturesensor" && \
        kafka-console-consumer.sh --topic interpreter.temperaturesensor --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 20 && \
        echo "consuming interpreter.doorsensor" && \
        kafka-console-consumer.sh --topic interpreter.doorsensor --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 20 && \
        echo "consuming interpreter.unassigendibottelemetry" && \
        kafka-console-consumer.sh --topic interpreter.unassignedibottelemetry --bootstrap-server localhost:9092 \
        '

    tmux select-layout even-vertical

    windowEndingPart
}

# create a new detached session
tmux new -s $SESSION -d

windowTopics
windowFirstConsumers
windowSecondConsumers

# remove first window
tmux select-window -t 0
tmux kill-window -t 0

# focus topics window
tmux select-window -t topics

# attach to the previously created session
tmux attach -d -t $SESSION

