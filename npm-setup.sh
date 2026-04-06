# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# Install Latest version of Node.js using nvm:
nvm install node

# Install specific version of Node.js using nvm (e.g., version 24):
nvm install 24

# Set the default Node.js version to the latest version:
nvm alias default node

# Set the default Node.js version to a specific version (e.g., version 24):
nvm alias default 24

# Verify the installation:
node -v
npm -v

# Shift between versions:
nvm use node  # Use the latest version
nvm use 24    # Use version 24

# List installed Node.js versions:
nvm ls

# Remove a specific Node.js version (e.g., version 24):
nvm uninstall 24

# Reuse packages from another version (e.g., from the 24 version to latest):
nvm install node --reinstall-packages-from=24
nvm install 24 --reinstall-packages-from=23 # Reuse packages from specific versions

# List globally installed npm packages:
npm list -g --depth=0

# Check outdated npm packages:
npm outdated -g --depth=0

# Update all global npm packages:
npm update -g

