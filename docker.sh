# Uninstall podman
podman ps -a
podman images
sudo apt remove --purge podman podman-docker buildah
sudo apt autoremove -y
rm -rf ~/.config/containers
rm -rf ~/.local/share/containers
sudo rm -rf /etc/containers
sudo rm -f /usr/bin/docker
alias | grep docker
getent group podman
sudo groupdel podman


# Install docker dependencies and remove conflicts
sudo apt update
sudo apt install ca-certificates curl gnupg -y
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)
sudo rm /etc/apt/sources.list.d/docker.sources
sudo rm /etc/apt/sources.list.d/docker.list 2>/dev/null


# Add docker to apt list and add keyrings - (change trixie to required debian version)
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian trixie stable" | sudo tee /etc/apt/sources.list.d/docker.list
curl -fsSL https://download.docker.com/linux/debian/gpg | \\nsudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg


# Install docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


# Reload terminal and check installation
source ~/.zshrc
docker --version
sudo systemctl status docker


# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
groups


# Restart and confirm working
sudo systemctl stop docker
sudo systemctl start docker
docker run hello-world
docker ps -a
docker rm 32149d697619 # change the container id
docker rmi hello-world
docker ps -a
docker images


# Stop and disable auto-start
sudo systemctl disable --now docker.service
sudo systemctl disable --now docker.socket
systemctl status docker
systemctl status docker.socket


# Start and stop
sudo systemctl start docker
sudo systemctl stop docker
sudo systemctl stop docker.socket
