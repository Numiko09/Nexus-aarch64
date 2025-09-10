#!/data/data/com.termux/files/usr/bin/bash
# Script to install nexus-network in Termux

ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then
    URL="https://github.com/Numiko09/Nexus-aarch64/releases/download/v0.1.0/nexus-network-aarch64-linux-android"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

echo "Downloading nexus-network for $ARCH..."
wget "$URL" -O ~/bin/nexus-network
chmod +x ~/bin/nexus-network
echo "Adding ~/bin to PATH..."
mkdir -p ~/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
source ~/.bashrc
echo "Verifying installation..."
nexus-network --version
