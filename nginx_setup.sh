#!/bin/bash

# 1. Update OS with latest patches
# The -y flag is vital so the script doesn't hang waiting for user input

echo "Updating system packages..."
apt-get update
apt-get upgrade -y

# 2. Install Nginx

echo "Installing Nginx..."
apt-get install nginx -y

# 3. Create Nginx configuration file

echo "Configuring Nginx as a Reverse Proxy..."
cat <<EOF > /etc/nginx/sites-available/vproapp
upstream vproapp {
    server app02:8080;
}
server {
    listen 80;
    location / {
        proxy_pass http://vproapp;
    }
}
EOF

# 4. Remove default Nginx configuration
# Using -f (force) prevents the script from failing if the file is already gone
rm -f /etc/nginx/sites-enabled/default

# 5. Create symbolic link to activate the site
# -s (symbolic) -f (force) to overwrite the link if it already exists
ln -sf /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

# 6. Restart Nginx to apply changes
echo "Restarting Nginx..."
systemctl restart nginx