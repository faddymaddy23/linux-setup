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


