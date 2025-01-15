#!/bin/bash

# Load user-defined PUID and PGID
USER_ID=${PUID:-1000}
GROUP_ID=${PGID:-1000}

# Ensure the user exists and permissions are updated
echo "Setting up user with UID: $USER_ID and GID: $GROUP_ID"
groupadd -g "$GROUP_ID" minecraft_group || echo "Group already exists"
useradd -u "$USER_ID" -g "$GROUP_ID" -m minecraft_user || echo "User already exists"

# Change ownership of the /minecraft directory
chown -R minecraft_user:minecraft_group /minecraft

# Verify the Java version
echo "Checking Java version..."
java -version || { echo "Java is not installed or the wrong version"; exit 1; }

# Start script
cd /minecraft || exit 1

if [[ -x "./startserver.sh" ]]; then
  START_SCRIPT="./startserver.sh"
else
  echo "Error: No valid start script found in /minecraft."
  exit 1
fi

echo "Using start script: $START_SCRIPT"

# Clean up the server.log file before starting
echo "Clearing previous server logs..."
> /minecraft/server.log

# Start the server in tmux session in the background
echo "Starting Minecraft server in tmux session..."
su minecraft_user -c "tmux new-session -d -s minecraft_server '$START_SCRIPT | tee -a /minecraft/server.log'"

# Prevent the container from exiting immediately
tail -f /minecraft/server.log

# Indicate to the user how to interact with the server
echo "To attach to the server console, run:"
echo "  docker exec -it $(hostname) tmux attach -t minecraft_server"
