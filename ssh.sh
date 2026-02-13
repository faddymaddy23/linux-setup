# Generate a Secure SSH Key (Recommended: ED25519)
mkdir -p ~/.ssh
ssh-keygen -t ed25519 -C "your_email@example.com"

# Change permissions
chmod 600 ~/.ssh/id_ed25519

# Display Public Key for Copying
cat ~/.ssh/id_ed25519.pub

# Add "config" file in ~/.ssh/
nano ~/.ssh/config

# Add servers in config file
Host connection-name
HostName ip_address or ssh.example.com
User user-name
Port number
IdentityFile ~/.ssh/id_ed25519

# Connection example
ssh connection-name


############################# Dynamic Port Forwarding #############################
# Let the client decide dynamically which destination to connect to.
ssh -N -D 5556 user@your_server_ip  # -N → Do not execute remote command (just tunnel) -D 5556 → Create SOCKS5 proxy on localhost port 5556
ssh -N -D 5556 -f user@your_server_ip # -f → run in background and stop using pkill -f "ssh -N -D 5556"

# Using config file
Host myproxy
    HostName your_server_ip
    User your_username
    DynamicForward 5556 # opens port 5556 on LOCAL MACHINE
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3
    ExitOnForwardFailure yes
# Connect using
ssh -N myproxy

sudo nano /etc/proxychains4.conf
dynamic_chain # uncomment it
proxy_dns # uncomment
strict_chain # comment it
socks4 # comment 
socks5  127.0.0.1 5556 # add at bottom

# Verify
proxychains curl https://api.ipify.org
curl --socks5 127.0.0.1:5556 https://api.ipify.org

# Launch service
proxychains firefox
chromium --proxy-server="socks5://127.0.0.1:5556" # directly add in browser



############################# Local Port Forwarding #############################
# Request coming to a local port will get forwarded to a specific destination.
# Tell server to connect specifically to a fixed destination e.g. google.com:443
ssh -L 8080:google.com:443 user@server

# Example: Forward your local port 8080 to a remote MySQL server localhost:3306 on your hosting server.
ssh -N -L 8080:localhost:3306 user@your_server_ip
ssh -f -N -L 8080:localhost:3306 user@your_server_ip # -f → run in background and stop using pkill -f "ssh -N -L 8080"

# Using config file
Host mylocalforward
    HostName your_server_ip
    User your_username
    IdentityFile ~/.ssh/id_rsa
    LocalForward 8080 localhost:3306   # Forward local port 8080 to server's localhost:3306
    ServerAliveInterval 60
    ServerAliveCountMax 3
    ExitOnForwardFailure yes
# connect using
ssh -N mylocalforward

# Verify the tunnel
ss -lntp | grep 8080

# Test connection
mysql -h 127.0.0.1 -P 8080 -u your_db_user -p

