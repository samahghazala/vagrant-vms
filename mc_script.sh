 #!/bin/bash

# 1. Update and install dependencies
echo "Installing Memcached..."
dnf update -y
dnf install epel-release -y
dnf install memcached -y

# 2. Configure Memcached to listen on all interfaces
# We target the 'OPTIONS' line specifically to change 127.0.0.1 to 0.0.0.0

echo "Configuring Memcached network settings..."
sed -i 's/-l 127.0.0.1/-l 0.0.0.0/g' /etc/sysconfig/memcached

# 3. Start and Enable the service
echo "Starting Memcached service..."
systemctl enable memcached
systemctl restart memcached



echo "Memcached setup complete."