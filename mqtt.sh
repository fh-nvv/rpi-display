#!/bin/bash

# MQTT settings
MQTT_BROKER="i.nvv.de"
MQTT_PORT=8883  # Default port for MQTT over SSL
MQTT_USERNAME="pi"
MQTT_PASSWORD="fQmHyyWz94jYpvraE6hV"
MQTT_CLIENT_ID=$(hostname)
MQTT_BASE_TOPIC="anzeiger"
MQTT_TOPIC="${MQTT_BASE_TOPIC}/${MQTT_CLIENT_ID}/status"
MQTT_TOPIC_T="${MQTT_BASE_TOPIC}/${MQTT_CLIENT_ID}/lastupdate"
MQTT_TOPIC_TELE="${MQTT_BASE_TOPIC}/${MQTT_CLIENT_ID}/tele"
MQTT_LWT_TOPIC="${MQTT_BASE_TOPIC}/${MQTT_CLIENT_ID}/status"
MQTT_LWT_MESSAGE="offline"
STATUS_MESSAGE="online"
SLEEP_INTERVAL=60
SESSION_EXPIRY_INTERVAL=120

# Function to send the online status message
send_status() {
  mosquitto_pub -h $MQTT_BROKER -p $MQTT_PORT -u $MQTT_USERNAME -P $MQTT_PASSWORD \
                -t $MQTT_TOPIC -m $STATUS_MESSAGE -i $MQTT_CLIENT_ID \
                --will-topic $MQTT_LWT_TOPIC --will-payload $MQTT_LWT_MESSAGE --will-qos 1 --will-retain \
                -x $SESSION_EXPIRY_INTERVAL -V mqttv5

  mosquitto_pub -h $MQTT_BROKER -p $MQTT_PORT -u $MQTT_USERNAME -P $MQTT_PASSWORD -r \
                -t $MQTT_TOPIC_T -m "$(date +%F) $(date +%T)" -i $MQTT_CLIENT_ID -V mqttv5
  mosquitto_pub -h $MQTT_BROKER -p $MQTT_PORT -u $MQTT_USERNAME -P $MQTT_PASSWORD -r \
                -t $MQTT_TOPIC_TELE -m "{\"lastupdate\": $(date +%s), \"status\": \"online\"}" -i $MQTT_CLIENT_ID -V mqttv5

}

# Send the last will message upon unexpected exit
trap 'mosquitto_pub -h $MQTT_BROKER -p $MQTT_PORT -u $MQTT_USERNAME -P $MQTT_PASSWORD \
                    -t $MQTT_LWT_TOPIC -m $MQTT_LWT_MESSAGE -r -i $MQTT_CLIENT_ID; \
      mosquitto_pub -h $MQTT_BROKER -p $MQTT_PORT -u $MQTT_USERNAME -P $MQTT_PASSWORD -r \
                    -t $MQTT_TOPIC_T -m "$(date +%F) $(date +%T)" -i $MQTT_CLIENT_ID -V mqttv5; \
      mosquitto_pub -h $MQTT_BROKER -p $MQTT_PORT -u $MQTT_USERNAME -P $MQTT_PASSWORD -r \
                    -t $MQTT_TOPIC_TELE -m "{\"lastupdate\": $(date +%s), \"status\": \"offline\"}" -i $MQTT_CLIENT_ID \
                    -V mqttv5; exit' SIGINT SIGTERM EXIT

# Send the initial online message
send_status

# Loop to send status every specified interval
while true; do
  sleep $SLEEP_INTERVAL
  send_status
done