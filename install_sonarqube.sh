#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Update system and install required packages
apt update
apt install -y wget unzip apt-transport-https gnupg2 curl openjdk-11-jdk postgresql postgresql-contrib

# Ensure PostgreSQL is running
systemctl start postgresql
systemctl enable postgresql

# Configure PostgreSQL for SonarQube
sudo -u postgres psql <<EOF
CREATE ROLE sonaruser WITH LOGIN ENCRYPTED PASSWORD 'admin123';
CREATE DATABASE sonarqube OWNER sonaruser;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonaruser;
EOF

# Download and install SonarQube
cd /opt
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.6.1.59531.zip
unzip -q sonarqube-9.6.1.59531.zip
mv sonarqube-9.6.1.59531 sonarqube
rm sonarqube-9.6.1.59531.zip

# Create a dedicated user for SonarQube
adduser --system --no-create-home --group --disabled-login sonarqube
chown -R sonarqube:sonarqube /opt/sonarqube

# Configure SonarQube database settings
cat <<EOT >> /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=sonaruser
sonar.jdbc.password=admin123
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
sonar.web.javaAdditionalOpts=-server
sonar.web.host=0.0.0.0   # Allow external access
EOT

# Set system limits for SonarQube
echo "vm.max_map_count=524288" >> /etc/sysctl.conf
echo "fs.file-max=131072" >> /etc/sysctl.conf
sysctl -p

# Set security limits for SonarQube
cat <<EOT >> /etc/security/limits.d/99-sonarqube.conf
sonarqube   -   nofile   131072
sonarqube   -   nproc    8192
EOT

# Create the systemd service file for SonarQube
cat <<EOT > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonarqube
Group=sonarqube
Restart=always
LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd daemon to recognize the new service
systemctl daemon-reload

# Start and enable SonarQube service
systemctl start sonarqube
systemctl enable sonarqube

# Check the status of the SonarQube service
systemctl status sonarqube

# Output message to indicate successful installation
echo "SonarQube installation is complete. Visit http://<YOUR_EC2_PUBLIC_IP>:9000 to access the dashboard."
