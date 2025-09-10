#!/data/data/com.termux/files/usr/bin/bash
# Script to install nexus-network in Termux

echo "Downloading nexus-network for aarch64..."
wget https://github.com/Numiko09/Nexus-aarch64/releases/download/v0.1.0/nexus-network-aarch64-linux-android -O ~/bin/nexus-network
chmod +x ~/bin/nexus-network
echo "Adding ~/bin to PATH..."
mkdir -p ~/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
source ~/.bashrc
echo "Verifying installation..."
nexus-network --version
