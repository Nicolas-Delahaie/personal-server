#!/bin/sh
set -eu

LOG_ARCHIVE_DIR=/tmp/youtube_stream_logs

# Already running check (no PID file needed)
if pgrep -f "rtmp://a.rtmp.youtube.com" > /dev/null 2>&1; then
    echo "Stream already running (PID: $(pgrep -f 'rtmp://a.rtmp.youtube.com'))"
    exit 0
fi

[ -z "$YOUTUBE_STREAM_KEY" ] && echo "ERROR: YOUTUBE_STREAM_KEY not set" >&2 && exit 1

# Archive previous log
if [ -f "$YOUTUBE_STREAM_LOG_FILE" ]; then
    mkdir -p "$LOG_ARCHIVE_DIR"
    mv "$YOUTUBE_STREAM_LOG_FILE" "$LOG_ARCHIVE_DIR/stream_$(date +%Y%m%d_%H%M%S).log"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Stream started" > "$YOUTUBE_STREAM_LOG_FILE"
nohup ffmpeg \
  -hide_banner -loglevel verbose \
  -rtsp_transport tcp \
  -i rtsp://127.0.0.1:8554/tapo_c200 \
  -c:v copy \
  -c:a aac -b:a 128k \
  -max_muxing_queue_size 1024 \
  -f flv "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}" \
  >> "$YOUTUBE_STREAM_LOG_FILE" 2>&1 &

echo "Stream started (PID: $!). Log: $YOUTUBE_STREAM_LOG_FILE"
