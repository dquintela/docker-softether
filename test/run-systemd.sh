#!/bin/bash

_term() { 
  echo "Caught SIGTERM signal!" 
  # kill -TERM "$child" 2>/dev/null
  systemctl --system start exit.target
}

trap _term SIGTERM

echo "Starting systemd...";
/lib/systemd/systemd --system &

child=$! 
wait "$child"
