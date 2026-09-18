#!/bin/bash

# 1. Update and install base dependencies
echo "Installing base dependencies..."
dnf update -y
dnf install epel-release wget -y

# 2. Install RabbitMQ Server

echo "Installing RabbitMQ..."
dnf install socat logrotate -y
dnf -y install centos-release-rabbitmq-38
dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server

# 3. Start and Enable RabbitMQ
echo "Starting RabbitMQ service..."
systemctl enable --now rabbitmq-server

# 4. Configure RabbitMQ
echo "Applying security and user configurations..."

# Allow remote connections 
sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'

# Add user 'test' with password 'test'
# We check if user exists first to avoid errors on re-runs
if ! rabbitmqctl list_users | grep -q "test"; then
    rabbitmqctl add_user test test
    rabbitmqctl set_user_tags test administrator
    rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
fi


# 6. Restart to apply config changes
echo "Restarting RabbitMQ..."
systemctl restart rabbitmq-server

echo "RabbitMQ setup complete."