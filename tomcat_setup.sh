#!/bin/bash

# 1. Update and Install Dependencies
echo "Installing Dependencies..."
dnf update -y
dnf install epel-release -y
dnf install java-11-openjdk java-11-openjdk-devel git wget maven -y

# 2. Prepare Tomcat Environment
echo "Setting up Tomcat user and directories..."
useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
mkdir -p /usr/local/tomcat

# 3. Download and Extract Tomcat
cd /tmp/
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
tar xzvf apache-tomcat-9.0.75.tar.gz
cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/

# 4. Create Tomcat Service File
echo "Creating Tomcat systemd service..."
cat <<EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat

ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh

SyslogIdentifier=tomcat-%i

[Install]
WantedBy=multi-user.target
EOF

# 5. Set Permissions and Start
chown -R tomcat:tomcat /usr/local/tomcat
chmod +x /usr/local/tomcat/bin/*.sh
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

# 6. Build and Deploy Application
echo "Cloning and building source code..."
cd /tmp/
rm -rf vprofile-project
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project

# UPDATING CONFIGURATION (Crucial for DevOps)
# Replace '' with your actual DB IP if you aren't using hostnames
#sed -i 's/db01/db02/' src/main/resources/application.properties
#sed -i 's/rmq01/rmq02/' src/main/resources/application.properties
#sed -i 's/mc01/mc02/' src/main/resources/application.properties

mvn install

# 7. Deployment
echo "Deploying artifact to Tomcat..."
systemctl stop tomcat
rm -rf /usr/local/tomcat/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
chown -R tomcat:tomcat /usr/local/tomcat/webapps/
systemctl start tomcat

echo "App setup complete!"

#To avoid the conflict we have to remove jdk17 pkgs which installed with maven
dnf remove maven -y
dnf remove -y java-17-openjdk-headless-1:17.0.18.0.8-2.el9.x86_64
systemctl restart tomcat
