# update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install apache2
sudo apt install apache2 -y

# Install mariadb
sudo apt install mariadb-server mariadb-client -y

# Install PHP
sudo apt install php php-mysql php-cli php-common php-curl php-gd php-mbstring php-xml php-xmlrpc php-zip php-imagick libapache2-mod-php -y

# Install phpmyadmin
sudo apt install phpmyadmin -y

# Configure PHP for Apache with Recommended changes
php --ini | grep "Loaded Configuration File"
# Note: The above command might path to php cli conf, go to apache2 folder there
sudo nano /etc/php/8.x/apache2/php.ini
# Change following
upload_max_filesize = 128M
post_max_size = 128M
memory_limit = 256M
max_execution_time = 180
max_input_time = 180
max_input_vars = 3000

# Optional: Usually auto created (Create /var/www/html Directory Structure)
sudo mkdir -p /var/www/html

# Set Correct Permissions and Ownership
sudo chown -R www-data:www-data /var/www/html
sudo find /var/www/html -type d -exec chmod 775 {} \;
sudo find /var/www/html -type f -exec chmod 664 {} \;
sudo usermod -a -G www-data $USER
sudo chmod -R g+w /var/www/html # not needed with 775 and 664

# Enable (optional) and start apache2 and mariadb
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl status apache2
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo systemctl status mariadb

# Test Apache and PHP
sudo nano /var/www/html/info.php
# add following and visit http://localhost/info.php
<?php
phpinfo();
?>
# after testing remove
sudo rm /var/www/html/info.php

# Configure phpMyAdmin by creating symlink and test http://localhost/phpmyadmin
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# Secure Your MySQL Root Account
## Set a password for root user
ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_strong_password_here';
## Remove anonymous users
DELETE FROM mysql.user WHERE User='';
## Disallow root login remotely (keep only localhost)
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
## Remove test database if it exists
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
## Reload privileges
FLUSH PRIVILEGES;
## Exit
EXIT;

# Test the New Password
sudo mysql -u root -p
