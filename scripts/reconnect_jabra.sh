#!/bin/bash

# Maximum retries
MAX_RETRIES=10
SLEEP_TIME=1  # seconds

SINK=""
SOURCE=""

for i in $(seq 1 $MAX_RETRIES); do
    SINK=$(pactl list short sinks | grep "Jabra_Link_380" | awk '{print $1}')
    if [ ! -z "$SINK" ]; then
        echo "Found Jabra sink: $SINK"
        pactl set-default-sink "$SINK"
        break
    fi
    echo "Waiting for Jabra sink to appear... ($i/$MAX_RETRIES)"
    sleep $SLEEP_TIME
done

if [ -z "$SINK" ]; then
    echo "Error: Jabra sink not found after $MAX_RETRIES seconds."
    exit 1
fi

# Wait a bit for source (microphone) to appear
sleep 1

SOURCE=$(pactl list short sources | grep -v "monitor" | grep "Jabra_Link_380" | awk '{print $1}')
if [ ! -z "$SOURCE" ]; then
    echo "Found Jabra source: $SOURCE"
    pactl set-default-source "$SOURCE"
else
    echo "No Jabra source found"
fi

echo "Jabra audio set as default sink/source successfully."
