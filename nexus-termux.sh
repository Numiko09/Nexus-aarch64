#!/data/data/com.termux/files/usr/bin/bash

# Скрипт для установки nexus-network (aarch64) на Termux

BINARY_URL="https://github.com/Numiko09/Nexus-aarch64/releases/download/v0.10.13-aarch64/nexus-network"
EXPECTED_SHA256="4f2ef1f69624e072b35966f8e69d720d3f508d12060e0106c622a3cc31fdca8a"
INSTALL_DIR="/data/data/com.termux/files/usr/bin"
BINARY_NAME="nexus-network"

echo "Installing nexus-network for Termux (aarch64)..."

if [ ! -d "/data/data/com.termux" ]; then
    echo "Error: This script must run in Termux!"
    exit 1
fi

pkg_install_wget() {
    if ! command -v wget >/dev/null 2>&1; then
        echo "Installing wget..."
        pkg update -y && pkg install wget -y
    fi
}

echo "Downloading nexus-network from $BINARY_URL..."
pkg_install_wget
wget -O /tmp/nexus-network "$BINARY_URL"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary!"
    exit 1
fi

echo "Verifying SHA256 checksum..."
COMPUTED_SHA256=$(sha256sum /tmp/nexus-network | cut -d' ' -f1)
if [ "$COMPUTED_SHA256" != "$EXPECTED_SHA256" ]; then
    echo "Error: SHA256 checksum mismatch!"
    echo "Expected: $EXPECTED_SHA256"
    echo "Got: $COMPUTED_SHA256"
    rm /tmp/nexus-network
    exit 1
fi

echo "Installing to $INSTALL_DIR/$BINARY_NAME..."
chmod +x /tmp/nexus-network
mv /tmp/nexus-network "$INSTALL_DIR/$BINARY_NAME"
if [ $? -ne 0 ]; then
    echo "Error: Failed to install binary!"
    exit 1
fi

if command -v $BINARY_NAME >/dev/null 2>&1; then
    echo "nexus-network installed successfully! Run 'nexus-network --help' to get started."
else
    echo "Error: Installation failed!"
    exit 1
fi
