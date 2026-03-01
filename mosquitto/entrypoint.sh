#!/bin/sh
# Generate password file from plaintext env vars
rm -f /mosquitto/passwd
mosquitto_passwd -b -c /mosquitto/passwd "$MQTT_LAN_USER" "$MQTT_LAN_PASSWORD"
chown mosquitto:mosquitto /mosquitto/passwd

# Delegate to the original entrypoint with the default CMD
exec /docker-entrypoint.sh mosquitto -c /mosquitto/config/mosquitto.conf