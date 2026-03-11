#!/bin/sh
set -eu

PID=$(pgrep -f "rtmp://a.rtmp.youtube.com")
if [ -z "$PID" ]; then
    echo "Stream not running"
    exit 0
fi

kill "$PID"
echo "Stream stopped (PID: $PID). Log: $YOUTUBE_STREAM_LOG_FILE"
