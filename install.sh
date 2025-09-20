#!/data/data/com.termux/files/usr/bin/bash

# Скрипт для установки nexus-network (aarch64) на Termux

BINARY_URL="https://github.com/Numiko09/Nexus-aarch64/releases/download/v0.1.2/nexus-network"
INSTALL_DIR="/data/data/com.termux/files/usr/bin"
BINARY_NAME="nexus-network"

# Проверка Termux
[ ! -d "/data/data/com.termux" ] && { echo "Error: Must run in Termux!"; exit 1; }

# Установка wget
command -v wget >/dev/null 2>&1 || { echo "Installing wget..."; pkg update -y && pkg install wget -y; }

# Скачивание
echo "Downloading nexus-network..."
wget -O "$INSTALL_DIR/$BINARY_NAME" "$BINARY_URL" || { echo "Error: Download failed!"; exit 1; }

# Установка
chmod +x "$INSTALL_DIR/$BINARY_NAME" || { echo "Error: Failed to set permissions!"; exit 1; }

# Проверка
command -v "$BINARY_NAME" >/dev/null 2>&1 && echo "nexus-network installed! Run 'nexus-network --help' to start." || { echo "Error: Installation failed!"; exit 1; }
