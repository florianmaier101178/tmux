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
        kafka-topics.sh --create --topic interpreter.cloudalarm --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.devicealarm --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.devicetelemetrykeepalive --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.fridgestate --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.history --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.telemetrykeepalive --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.unassignedibottelemetry --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.temperaturesensor --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.doorsensor --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.ibottelemetrykeepalive --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic interpreter.ibotbattery --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --describe --topic interpreter.cloudalarm --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.devicealarm --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.devicetelemetrykeepalive --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.fridgestate --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.history --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.telemetrykeepalive --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.temperaturesensor --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.doorsensor --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.ibotbattery --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.ibottelemetrykeepalive --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic interpreter.unassignedibottelemetry --zookeeper 127.0.0.1:2181; \
    ")'

    windowEndingPart 
}

function windowFirstConsumers() {
    WINDOW_NAME=consumers-1

    windowBeginningPart $WINDOW_NAME

    tmux split-window '
        sleep 15 && \
        echo "consuming interpreter.cloudalarm" && \
        kafka-console-consumer.sh --topic interpreter.cloudalarm --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 15 && \
        echo "consuming interpreter.devicealarm" && \
        kafka-console-consumer.sh --topic interpreter.devicealarm --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 15 && \
        echo "consuming interpreter.devicetelemetrykeepalive" && \
        kafka-console-consumer.sh --topic interpreter.devicetelemetrykeepalive --bootstrap-server localhost:9092 \
        '

    tmux select-layout even-vertical

    windowEndingPart
}

function windowSecondConsumers() {
    WINDOW_NAME=consumers-2

    windowBeginningPart $WINDOW_NAME

    tmux split-window '
        sleep 20 && \
        echo "consuming interpreter.fridgestate" && \
        kafka-console-consumer.sh --topic interpreter.fridgestate --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 20 && \
        echo "consuming interpreter.history" && \
        kafka-console-consumer.sh --topic interpreter.history --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 20 && \
        echo "consuming interpreter.telemetrykeepalive" && \
        kafka-console-consumer.sh --topic interpreter.telemetrykeepalive --bootstrap-server localhost:9092 \
        '

    tmux select-layout even-vertical

    windowEndingPart
}

function windowThirdConsumers() {
    WINDOW_NAME=consumers-3

    windowBeginningPart $WINDOW_NAME

    tmux split-window '
        sleep 25 && \
        echo "consuming interpreter.temperaturesensor" && \
        kafka-console-consumer.sh --topic interpreter.temperaturesensor --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 25 && \
        echo "consuming interpreter.doorsensor" && \
        kafka-console-consumer.sh --topic interpreter.doorsensor --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 25 && \
        echo "consuming interpreter.ibotbattery" && \
        kafka-console-consumer.sh --topic interpreter.ibotbattery --bootstrap-server localhost:9092 \
        '

    tmux select-layout even-vertical

    windowEndingPart
}

function windowFourthConsumers() {
    WINDOW_NAME=consumers-4

    windowBeginningPart $WINDOW_NAME

    tmux split-window '
        sleep 30 && \
        echo "consuming interpreter.ibottelemetrykeepalive" && \
        kafka-console-consumer.sh --topic interpreter.ibottelemetrykeepalive --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 30 && \
        echo "consuming interpreter.unassignedibottelemetry" && \
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
windowThirdConsumers
windowFourthConsumers

# remove first window
tmux select-window -t 0
tmux kill-window -t 0

# focus topics window
tmux select-window -t topics

# attach to the previously created session
tmux attach -d -t $SESSION

