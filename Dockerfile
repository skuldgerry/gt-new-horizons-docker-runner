FROM debian:bullseye-slim

# Install required dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  openjdk-17-jre-headless \
  tmux \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /minecraft

# Entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Default environment variables for UID and GID
ENV PUID=1000
ENV PGID=1000

# Expose Minecraft server port
EXPOSE 25565

# Entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
