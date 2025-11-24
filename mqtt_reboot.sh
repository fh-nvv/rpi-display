#!/bin/bash

# MQTT settings
MQTT_BROKER="i.nvv.de"
MQTT_PORT=8883  # Default port for MQTT over SSL
MQTT_USERNAME="pi"
MQTT_PASSWORD="fQmHyyWz94jYpvraE6hV"
MQTT_CLIENT_ID=$(hostname)
MQTT_BASE_TOPIC="anzeiger"
MQTT_TOPIC="${MQTT_BASE_TOPIC}/${MQTT_CLIENT_ID}/status"
MQTT_LWT_TOPIC="${MQTT_BASE_TOPIC}/${MQTT_CLIENT_ID}/status"
MQTT_LWT_MESSAGE="offline"
STATUS_MESSAGE="reboot"
SLEEP_INTERVAL=60
SESSION_EXPIRY_INTERVAL=120

# Function to send the online status message
send_status() {
  mosquitto_pub -h $MQTT_BROKER -p $MQTT_PORT -u $MQTT_USERNAME -P $MQTT_PASSWORD \
                -t $MQTT_TOPIC -m $STATUS_MESSAGE -r -i $MQTT_CLIENT_ID \
                --will-topic $MQTT_LWT_TOPIC --will-payload $MQTT_LWT_MESSAGE --will-qos 1 --will-retain \
                -x $SESSION_EXPIRY_INTERVAL
}

# Send the initial online message
send_status
