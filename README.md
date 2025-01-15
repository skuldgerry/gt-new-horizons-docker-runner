# Minecraft Server Runner GT New Horizons

This repository contains a Docker image designed as a **runner only** for hosting a Minecraft **GT New Horizons** server. It is mod-agnostic, meaning it does not include any specific mod files or configurations beyond what is necessary to run the server. Users are responsible for downloading and setting up the appropriate server version and mod files according to their needs.

## Getting Started

Follow these steps to set up and run your Minecraft server:

### 1. Prepare the Server Files

1. **Create a directory** on your host machine to store the Minecraft server files:

   ```bash
   mkdir /path/to/minecraft-server
   ```

2. **Download the Minecraft latest JAVA 17+ [server files](http://downloads.gtnewhorizons.com/ServerPacks/)** into this directory:

   ```bash
   wget http://downloads.gtnewhorizons.com/ServerPacks/<latest_url>
   ```

   Replace `<latest_url>` with the URL of the desired server version.

3. **Install unzip** if not already installed (required to extract the server files):

   ```bash
   sudo apt install unzip  # Adjust for your package manager
   ```

4. **Extract the server files**:

   ```bash
   unzip <downloaded-server-file> -d /path/to/minecraft-server
   ```

5. **Accept the EULA** by editing the `eula.txt` file:

   ```bash
   echo "eula=true" > /path/to/minecraft-server/eula.txt
   ```

6. **Rename the startup script** to `startserver.sh`:

   ```bash
   mv /path/to/minecraft-server/<original-script-name> /path/to/minecraft-server/startserver.sh
   ```

   Replace `<original-script-name>` with the actual name of the script included in the server files.

7. **Make the script executable**:

   ```bash
   chmod +x /path/to/minecraft-server/startserver.sh
   ```

8. (Optional) **Download and configure server utilities**:

   - Navigate to the `mods` directory:
     ```bash
     cd /path/to/minecraft-server/mods
     ```
   - Download the latest release of [Server Utilities](https://github.com/GTNewHorizons/ServerUtilities/releases):
     ```bash
     wget <latest_release_url>
     ```
   - Make the necessary configuration adjustments as per the [official documentation](https://gtnh.miraheze.org/wiki/Server_Setup_(Linux,_Oracle_Cloud)#Install_a_mod_for_backups).

### 2. Deploy the Docker Stack

Create a `docker-compose.yml` file with the following content:

```yaml
services:
  gt-new-horizons-server:
    image: skuldgerry/gt-new-horizons-runner:1.0.0
    container_name: gt-new-horizons
    environment:
      - PUID=1000 # User ID to match the host user's UID
      - PGID=1000 # Group ID to match the host user's GID
    volumes:
      - /path/to/minecraft-server:/minecraft:rw # Bind server files directory
    ports:
      - "25565:25565" # Default Minecraft server port
    restart: unless-stopped
```

- Adjust the `PUID` and `PGID` to match your host user and group IDs to ensure proper permissions.

Start the stack:

```bash
docker-compose up -d
```

### 3. Access Logs

To view the server logs:

```bash
docker logs -f gt-new-horizons
```

### 4. Access the Console

To interact with the Minecraft server console:

1. Attach to the Docker container as the correct user:

   ```bash
   docker exec -it --user minecraft_user gt-new-horizons bash
   ```

2. Attach to the `tmux` session:

   ```bash
   tmux attach -t minecraft_server
   ```

3. To detach from the `tmux` session without stopping the server, press `Ctrl+b`, then `d`.

## Build the Docker Image Locally

If you want to build the image yourself:

1. Clone this repository:
   ```bash
   git clone https://github.com/skuldgerry/gt-new-horizons-docker-runner.git
   cd gt-new-horizons-docker-runner
   ```

2. Build the image using Docker:
   ```bash
   docker build -t skuldgerry/gt-new-horizons-runner:local .
   ```

3. Replace the image name in your `docker-compose.yml` file with `skuldgerry/gt-new-horizons-runner:local` and deploy the stack as described above.

## Notes

- The Docker image is designed as a **runner only** and does not include utilities for downloading or configuring the server files. Ensure the files are prepared as described above before starting the container.
- Logs are automatically written to `/minecraft/server.log` and output to the Docker logs for debugging.
- The image and associated tools were developed with extensive AI assistance.

Feel free to suggest improvements or report issues in the repository!
