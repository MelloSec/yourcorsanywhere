#!/bin/bash

user="azureuser"
delete_sessions=false

# Parse command-line options
while getopts ":d" option; do
  case $option in
    d)
      delete_sessions=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Create or delete sessions based on the option
if [ "$delete_sessions" = true ]; then
  tmux kill-session -t cors 2>/dev/null
  tmux kill-session -t capture 2>/dev/null
else
  # Create detached session "capture" and send commands
  tmux new-session -d -s capture
  tmux send-keys -t capture "mkdir /home/$user/yourcorsanywhere/capture-server/certs" Enter
  # tmux send-keys -t capture "mkdir /home/$user/certs" Enter
  # tmux send-keys -t capture "cd certs" Enter
  tmux send-keys -t capture "cp /home/$user/certs/* /home/$user/yourcorsanywhere/capture-server/certs/" Enter
  tmux send-keys -t capture "sudo chmod +x /home/$user/yourcorsanywhere/capture-server/capturetoken.py" Enter
  tmux send-keys -t capture "sudo python3 /home/$user/yourcorsanywhere/capture-server/capturetoken.py" Enter
fi
