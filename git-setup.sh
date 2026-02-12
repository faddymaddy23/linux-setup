# Verify Git Is Installed
sudo apt update
sudo apt install git -y
git --version

# Configure Git Identity
git config --global user.name "Your Full Name"
git config --global user.email "your_email@example.com"
git config --global --list

# Generate a Secure SSH Key (Recommended: ED25519)
mkdir -p ~/.ssh
ssh-keygen -t ed25519 -C "your_email@example.com"

# Start ssh agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
ssh-add -l

# Display Public Key for Copying
cat ~/.ssh/id_ed25519.pub

# "Copy the above SSH public key and add it to your Git hosting service (e.g., GitHub, GitLab)."

# Test GitHub SSH Connection
ssh -T git@github.com
# Test GitLab SSH Connection
ssh -T git@gitlab.com

# Force Git to use SSH instead of HTTPS
git config --global url."git@github.com:".insteadOf "https://github.com/"

# Verify Full Setup
git config --global --list
# check file permissions
ls -l ~/.ssh

# Git usage example
git clone https://gitlab.com/Web/repo-name.git
cd repo-name
git checkout development  
git checkout -b feature/name
git add . # after making changes
git commit -m "added name feature"   
git push origin feature/name
git checkout development

git merge --no-ff feature/name
git tag 1.0.1
git push origin development --tags

git pull origin development