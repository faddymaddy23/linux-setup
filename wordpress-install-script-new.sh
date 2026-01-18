#!/bin/bash
# WordPress Installation Script
# Run without sudo as your regular user (after changing the execution permissions)

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if WP-CLI is installed
if ! command -v wp &> /dev/null; then
    print_error "WP-CLI is not installed. Please install it first."
    echo "Install with: curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"
    echo "Then: chmod +x wp-cli.phar && sudo mv wp-cli.phar /usr/local/bin/wp"
    exit 1
fi

# Get current user
CURRENT_USER=$(whoami)

# Prompt for website name
read -p "Enter the website name (e.g., mysite): " WEBSITE_NAME

# Validate website name
if [[ -z "$WEBSITE_NAME" ]]; then
    print_error "Website name cannot be empty!"
    exit 1
fi

# Check if directory already exists
WP_DIR="/var/www/html/$WEBSITE_NAME"
if [ -d "$WP_DIR" ]; then
    print_error "Directory $WP_DIR already exists!"
    read -p "Do you want to delete it and continue? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo "Installation cancelled."
        exit 1
    fi
    sudo rm -rf "$WP_DIR"
fi

# Prompt for MySQL root password
echo ""
print_warning "MySQL root password is required to create the database"
read -sp "Enter MySQL root password: " DB_ROOT_PASS
echo ""

# Test MySQL connection
if ! sudo mysql -u root -p"$DB_ROOT_PASS" -e "SELECT 1;" &> /dev/null; then
    print_error "Failed to connect to MySQL. Please check your root password."
    exit 1
fi
print_success "MySQL connection successful"

# Define variables
DB_NAME="$WEBSITE_NAME"
DB_USER="root"
DB_PASS="$DB_ROOT_PASS"
DB_HOST="localhost"
SITE_URL="localhost/$WEBSITE_NAME"
SITE_TITLE="$WEBSITE_NAME"
ADMIN_USER="admin"
ADMIN_PASSWORD="admin"
ADMIN_EMAIL="admin@yopmail.com"

echo ""
echo "=========================================="
echo "Installation Configuration:"
echo "=========================================="
echo "Website Name: $WEBSITE_NAME"
echo "Database Name: $DB_NAME"
echo "Database User: $DB_USER"
echo "Site URL: http://$SITE_URL"
echo "Admin User: $ADMIN_USER"
echo "Admin Password: $ADMIN_PASSWORD"
echo "Admin Email: $ADMIN_EMAIL"
echo "=========================================="
echo ""
read -p "Continue with installation? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Installation cancelled."
    exit 1
fi

# Create directory with proper ownership
echo ""
print_warning "Creating WordPress directory..."
sudo mkdir -p "$WP_DIR"
sudo chown -R $CURRENT_USER:www-data "$WP_DIR"
sudo chmod -R 775 "$WP_DIR"
print_success "Directory created: $WP_DIR"

# Create the MySQL database
print_warning "Creating database..."
sudo mysql -u root -p"$DB_ROOT_PASS" <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
MYSQL_SCRIPT

if [ $? -eq 0 ]; then
    print_success "Database '$DB_NAME' created successfully"
else
    print_error "Failed to create database"
    exit 1
fi

# Download WordPress (now as current user, no --allow-root)
print_warning "Downloading WordPress..."
wp core download --path="$WP_DIR"
print_success "WordPress downloaded"

# Create wp-config.php
print_warning "Creating wp-config.php..."
wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASS" \
    --dbhost="$DB_HOST" \
    --path="$WP_DIR"
print_success "wp-config.php created"

# Set debugging configuration
print_warning "Configuring WordPress settings..."
wp config set WP_DEBUG true --raw --path="$WP_DIR"
wp config set WP_DEBUG_LOG true --raw --path="$WP_DIR"
wp config set WP_DEBUG_DISPLAY false --raw --path="$WP_DIR"
wp config set FS_METHOD 'direct' --path="$WP_DIR"
print_success "WordPress configuration updated"

# Install WordPress
print_warning "Installing WordPress..."
wp core install \
    --url="$SITE_URL" \
    --title="$SITE_TITLE" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="$ADMIN_EMAIL" \
    --path="$WP_DIR"
print_success "WordPress installed"

# Install plugins
print_warning "Installing plugins..."
wp plugin install wp-crontrol --path="$WP_DIR"
print_success "Plugins installed"

# Activate all plugins
print_warning "Activating plugins..."
wp plugin activate --all --path="$WP_DIR"
print_success "Plugins activated"

# Delete default plugins
print_warning "Removing default plugins..."
wp plugin delete akismet hello --path="$WP_DIR" 2>/dev/null || true
print_success "Default plugins removed"

# Delete default content
print_warning "Removing default posts and pages..."
wp post delete 1 --force --path="$WP_DIR" 2>/dev/null || true
wp post delete 2 --force --path="$WP_DIR" 2>/dev/null || true
wp post delete 3 --force --path="$WP_DIR" 2>/dev/null || true  # Privacy Policy page
print_success "Default content removed"

# Set permalink structure
print_warning "Setting permalink structure..."
wp rewrite structure '/%postname%/' --path="$WP_DIR"
wp rewrite flush --path="$WP_DIR"
print_success "Permalinks configured"

# Create sample users
print_warning "Creating sample users..."
wp user create user user@yopmail.com --role=subscriber --user_pass=admin --display_name="user" --path="$WP_DIR" 2>/dev/null || true
wp user create user1 user1@yopmail.com --role=subscriber --user_pass=admin --display_name="user1" --path="$WP_DIR" 2>/dev/null || true
print_success "Sample users created"

# Set proper ownership and permissions for Apache
print_warning "Setting final file permissions..."
sudo chown -R www-data:www-data "$WP_DIR"
sudo find "$WP_DIR" -type d -exec chmod 775 {} \;
sudo find "$WP_DIR" -type f -exec chmod 664 {} \;
print_success "Permissions set correctly"

# Create .htaccess if it doesn't exist
if [ ! -f "$WP_DIR/.htaccess" ]; then
    print_warning "Creating .htaccess file..."
    sudo touch "$WP_DIR/.htaccess"
    sudo chown www-data:www-data "$WP_DIR/.htaccess"
    sudo chmod 644 "$WP_DIR/.htaccess"
    print_success ".htaccess created"
fi

echo ""
echo "=========================================="
print_success "WordPress site '$WEBSITE_NAME' installed successfully!"
echo "=========================================="
echo ""
echo "🌐 Site URL: http://$SITE_URL"
echo "🔐 Admin URL: http://$SITE_URL/wp-admin"
echo "👤 Admin Username: $ADMIN_USER"
echo "🔑 Admin Password: $ADMIN_PASSWORD"
echo ""
echo "=========================================="