#!/bin/bash

# MQTT Broker configuration
BROKER="i.nvv.de" # Replace with your MQTT broker address
PORT=8883                # Replace with your MQTT broker port if different
TOPIC="anzeiger/$HOSTNAME/order"         # Replace with the topic you want to subscribe to
USER=pi
PASSWORD=fQmHyyWz94jYpvraE6hV
# Function to handle received messages
handle_message() {
    local payload="$1"

    # Parse the payload and execute commands based on the message content
    case "$payload" in
        ("screenshot")
            ~/screenshot.sh
            ;;
        ("refresh")
            ~/refresh.sh
            ;;
        ("UPDATE_SYSTEM")
            echo "Updating the system..."
            # Command to update the system
            apt-get update && apt-get upgrade -y
            ;;
        (*)
            ~/sh/$payload.sh
            ;;
    esac
}

# Subscribe to the MQTT topic and process incoming messages
mosquitto_sub -h $BROKER -p $PORT -t $TOPIC -u $USER -P $PASSWORD | while read -r message
do
    handle_message "$message"
done
