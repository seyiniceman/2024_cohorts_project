#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Update package index
sudo apt-get update

# Install Java 8 (Nexus requires Java)
sudo apt install -y openjdk-8-jre-headless

# Navigate to /opt and download Nexus
cd /opt
sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz

# Extract the Nexus archive
sudo tar -zxvf latest-unix.tar.gz

# Move the extracted Nexus folder to a cleaner location
sudo mv /opt/nexus-3.* /opt/nexus

# Create a new user for Nexus
sudo adduser --system --no-create-home --group nexus

# Grant the Nexus user sudo privileges without requiring a password
echo "nexus ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

# Set correct ownership for the Nexus directories
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work

# Update the Nexus startup configuration
echo 'run_as_user="nexus"' | sudo tee /opt/nexus/bin/nexus.rc

# Configure JVM options
sudo bash -c 'cat <<EOT > /opt/nexus/bin/nexus.vmoptions
-Xms1024m
-Xmx1024m
-XX:MaxDirectMemorySize=1024m
-XX:LogFile=./sonatype-work/nexus3/log/jvm.log
-XX:-OmitStackTraceInFastThrow
-Djava.net.preferIPv4Stack=true
-Dkaraf.home=.
-Dkaraf.base=.
-Dkaraf.etc=etc/karaf
-Djava.util.logging.config.file=/etc/karaf/java.util.logging.properties
-Dkaraf.data=./sonatype-work/nexus3
-Dkaraf.log=./sonatype-work/nexus3/log
-Djava.io.tmpdir=./sonatype-work/nexus3/tmp
EOT'

# Create Nexus systemd service file
sudo bash -c 'cat <<EOT > /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOT'

# Reload systemd to apply the new service file
sudo systemctl daemon-reload

# Start and enable Nexus service to start on boot
sudo systemctl start nexus
sudo systemctl enable nexus

# Display the status of Nexus service
sudo systemctl status nexus
