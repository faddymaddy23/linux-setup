# website link for latest version https://protonvpn.com/support/official-linux-vpn-debian/

wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb
sudo dpkg -i ./protonvpn-stable-release_1.0.8_all.deb && sudo apt update

# do not worry about gnome it is just named like this
sudo apt install proton-vpn-gnome-desktop