#!/bin/bash

# Important Note: 
## Run without sudo (after changing the execution permissions)
## It will only work if database user 'root' has no password set.

# Prompt for website name
read -p "Enter the website name: " WEBSITE_NAME

# Define variables based on input
DB_NAME="$WEBSITE_NAME"
DB_USER="root"
DB_PASS=""
DB_HOST="localhost"
WP_DIR="/var/www/html/$WEBSITE_NAME"
SITE_URL="localhost/$WEBSITE_NAME"
SITE_TITLE="$WEBSITE_NAME"
ADMIN_USER="admin"
ADMIN_PASSWORD="admin"
ADMIN_EMAIL="admin@yopmail.com"

# Ensure the directory exists
sudo mkdir -p "$WP_DIR"

# Set the correct ownership to your user and Apache (www-data)
# This gives your user full control, and Apache can read/serve files
sudo chown -R www-data:www-data "$WP_DIR"  # Allow user to manage files
sudo chmod -R 775 "$WP_DIR"  # Ensure appropriate permissions

# Create the MySQL database
sudo mysql -u "$DB_USER" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# Download WordPress
wp core download --path="$WP_DIR"

# Create the wp-config.php file
wp config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS" --dbhost="$DB_HOST" --path="$WP_DIR"

# Set FS_METHOD to 'direct' in wp-config
#wp config set FS_METHOD direct --raw --path="$WP_DIR"

# Set debugging to true and debug display to false
wp config set WP_DEBUG true --raw --path="$WP_DIR"
wp config set WP_DEBUG_LOG true --raw --path="$WP_DIR"
wp config set WP_DEBUG_DISPLAY false --raw --path="$WP_DIR"

# Create the database (if not already created)
wp db create --path="$WP_DIR"

# Install WordPress
wp core install --url="$SITE_URL" --title="$SITE_TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL" --path="$WP_DIR"

# Install plugins
wp plugin install wp-crontrol --path="$WP_DIR"

# Activate plugins
wp plugin activate --all --path="$WP_DIR"

# Delete default plugins (akismet, hello)
wp plugin delete akismet hello --path="$WP_DIR"

# Delete default post and page
wp post delete 1 --force --path="$WP_DIR" # deletes the "Hello world!" post
wp post delete 2 --force --path="$WP_DIR" # deletes the "Sample Page"

# Set permalink structure
wp rewrite structure '%postname%' --path="$WP_DIR"

# Create sample users
wp user create user user@yopmail.com --role=subscriber --user_pass=admin --display_name="user" --path="$WP_DIR"
wp user create user1 user1@yopmail.com --role=subscriber --user_pass=admin --display_name="user1" --path="$WP_DIR"

# Set proper permissions for the WordPress files after installation
sudo chown -R www-data:www-data "$WP_DIR"  # Ensure that you have control over the files
sudo chmod -R 775 "$WP_DIR"  # Ensure that files have appropriate permissions for both you and Apache

echo "WordPress site '$WEBSITE_NAME' installed successfully at $SITE_URL!"