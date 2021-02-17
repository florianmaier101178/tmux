#!/bin/bash

SESSION="kafka-workflowhandler"

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
        kafka-topics.sh --create --topic workflowhandler.ibotpairingstates --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic workflowhandler.ibotconfigurationcommands --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic workflowhandler.ibotconfigurationstates --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --create --topic workflowhandler.offboardingstates --replication-factor 2 --partitions 4 --bootstrap-server localhost:9092; \
        kafka-topics.sh --describe --topic workflowhandler.ibotpairingstates --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic workflowhandler.ibotconfigurationcommands --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic workflowhandler.ibotconfigurationstates --zookeeper 127.0.0.1:2181; \
        kafka-topics.sh --describe --topic workflowhandler.offboardingstates --zookeeper 127.0.0.1:2181; \
    ")'

    windowEndingPart 
}

function windowFirstConsumers() {
    WINDOW_NAME=consumers-1

    windowBeginningPart $WINDOW_NAME

    tmux split-window '
        sleep 15 && \
        echo "consuming workflowhandler.ibotpairingstates" && \
        kafka-console-consumer.sh --topic workflowhandler.ibotpairingstates --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 15 && \
        echo "consuming workflowhandler.offboardingstates" && \
        kafka-console-consumer.sh --topic workflowhandler.offboardingstates --bootstrap-server localhost:9092 \
        '

    tmux select-layout even-vertical

    windowEndingPart
}

function windowSecondConsumers() {
    WINDOW_NAME=consumers-2

    windowBeginningPart $WINDOW_NAME

    tmux split-window '
        sleep 20 && \
        echo "consuming workflowhandler.ibotconfigurationcommands" && \
        kafka-console-consumer.sh --topic workflowhandler.ibotconfigurationscommands --bootstrap-server localhost:9092 \
        '
    tmux split-window '
        sleep 20 && \
        echo "consuming workflowhandler.ibotconfigurationstates" && \
        kafka-console-consumer.sh --topic workflowhandler.ibotconfigurationstates --bootstrap-server localhost:9092 \
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

