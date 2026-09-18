#!/bin/bash

# 1. Update OS and Install Packages
echo "Updating OS and installing MariaDB..."
dnf update -y
dnf install epel-release -y
dnf install git mariadb-server -y

# 2. Starting & Enabling MariaDB
echo "Starting MariaDB service..."
systemctl start mariadb
systemctl enable mariadb

# 3. Security Lockdown (Non-interactive)
DB_ROOT_PASSWORD="admin123"
echo "Starting MariaDB Security Lockdown..."

# Set root password
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD'; FLUSH PRIVILEGES;"

# Remove anonymous users
mysql -u root -p"$DB_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='';"

# Remove test database
mysql -u root -p"$DB_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS test; DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';"

# Final Reload
mysql -u root -p"$DB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
echo "Security Lockdown Complete!"

# 4. Database Configuration
echo "Creating database and user..."
mysql -u root -p"$DB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS accounts;"
mysql -u root -p"$DB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123';"
mysql -u root -p"$DB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# 5. Download Source code & Initialize Database
echo "Cloning repository and initializing schema..."
cd /tmp/
rm -rf vprofile-project
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project

# Import the backup file
mysql -u root -p"$DB_ROOT_PASSWORD" accounts < src/main/resources/db_backup.sql

# 6. Verification & Restart
echo "Verifying tables..."
mysql -u root -p"$DB_ROOT_PASSWORD" accounts -e "SHOW TABLES;"

echo "Restarting MariaDB..."
systemctl restart mariadb

echo "Database Setup Finished!"