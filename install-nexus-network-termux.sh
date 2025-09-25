#!/data/data/com.termux/files/usr/bin/bash

# Script to install nexus-network aarch64 binary in Termux
# Repository: https://github.com/Numiko09/Nexus-aarch64
# Binary: nexus-network from binaries/ directory in main branch
# Target: Android ARM64 (API level 30+)
# Tested in Termux on Android 10+ with ARM64
# License: Apache-2.0/MIT (same as nexus-cli)

# Exit on any error
set -e

# Define key variables
REPO_OWNER="Numiko09"
REPO_NAME="Nexus-aarch64"
BRANCH="main"
BINARY_NAME="nexus-network"
DOWNLOAD_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/binaries/${BINARY_NAME}"
EXPECTED_SHA256="4f2ef1f69624e072b35966f8e69d720d3f508d12060e0106c622a3cc31fdca8a"
INSTALL_DIR="/data/data/com.termux/files/usr/bin"
BINARY_PATH="${INSTALL_DIR}/${BINARY_NAME}"
TEMP_BINARY="/tmp/${BINARY_NAME}"
LOG_FILE="$HOME/nexus-network-install.log"

# Print welcome message and log
echo "Installing nexus-network for Termux (aarch64)..." | tee "$LOG_FILE"
echo "Binary will be downloaded from: $DOWNLOAD_URL" | tee -a "$LOG_FILE"
echo "Installation directory: $INSTALL_DIR" | tee -a "$LOG_FILE"
echo "Log file: $LOG_FILE" | tee -a "$LOG_FILE"

# Step 1: Verify Termux environment
echo "Checking if running in Termux..." | tee -a "$LOG_FILE"
if [ ! -d "/data/data/com.termux" ]; then
    echo "Error: This script must be run in Termux!" | tee -a "$LOG_FILE"
    exit 1
fi

# Step 2: Install wget if not present
echo "Checking for wget..." | tee -a "$LOG_FILE"
if ! command -v wget >/dev/null 2>&1; then
    echo "Installing wget..." | tee -a "$LOG_FILE"
    pkg update -y && pkg install wget -y
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install wget!" | tee -a "$LOG_FILE"
        exit 1
    fi
else
    echo "wget is already installed." | tee -a "$LOG_FILE"
fi

# Step 3: Check if binary already exists
echo "Checking if $BINARY_NAME already exists..." | tee -a "$LOG_FILE"
if [ -f "$BINARY_PATH" ]; then
    echo "Binary already exists at $BINARY_PATH. Skipping download. To reinstall, remove $BINARY_PATH first." | tee -a "$LOG_FILE"
else
    # Step 4: Download the binary
    echo "Downloading nexus-network from $DOWNLOAD_URL..." | tee -a "$LOG_FILE"
    wget -O "$TEMP_BINARY" "$DOWNLOAD_URL"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to download binary from $DOWNLOAD_URL!" | tee -a "$LOG_FILE"
        echo "Please check if the file exists in the repository at binaries/${BINARY_NAME}." | tee -a "$LOG_FILE"
        exit 1
    fi
    echo "Download completed." | tee -a "$LOG_FILE"

    # Step 5: Verify SHA256 checksum
    echo "Verifying SHA256 checksum..." | tee -a "$LOG_FILE"
    COMPUTED_SHA256=$(sha256sum "$TEMP_BINARY" | cut -d' ' -f1)
    if [ "$COMPUTED_SHA256" != "$EXPECTED_SHA256" ]; then
        echo "Error: SHA256 checksum mismatch!" | tee -a "$LOG_FILE"
        echo "Expected: $EXPECTED_SHA256" | tee -a "$LOG_FILE"
        echo "Got: $COMPUTED_SHA256" | tee -a "$LOG_FILE"
        rm "$TEMP_BINARY"
        exit 1
    fi
    echo "SHA256 checksum verified." | tee -a "$LOG_FILE"

    # Step 6: Install the binary
    echo "Installing to $BINARY_PATH..." | tee -a "$LOG_FILE"
    chmod +x "$TEMP_BINARY"
    mv "$TEMP_BINARY" "$BINARY_PATH"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install binary! Check write permissions for $INSTALL_DIR." | tee -a "$LOG_FILE"
        exit 1
    fi
    echo "Binary installed successfully." | tee -a "$LOG_FILE"
fi

# Step 7: Verify the binary is executable
echo "Verifying binary..." | tee -a "$LOG_FILE"
if command -v "$BINARY_NAME" >/dev/null 2>&1; then
    echo "Testing binary: $BINARY_NAME --help" | tee -a "$LOG_FILE"
    "$BINARY_PATH" --help
    if [ $? -eq 0 ]; then
        echo "Success: nexus-network installed and runs correctly!" | tee -a "$LOG_FILE"
    else
        echo "Error: Binary failed to run! Check compatibility or logs in $LOG_FILE." | tee -a "$LOG_FILE"
        exit 1
    fi
else
    echo "Error: Binary not found in PATH! Ensure $INSTALL_DIR is in PATH or installation failed." | tee -a "$LOG_FILE"
    exit 1
fi

# Step 8: Final instructions
echo "Installation complete!" | tee -a "$LOG_FILE"
echo "nexus-network is installed at: $BINARY_PATH" | tee -a "$LOG_FILE"
echo "Run the following to use it:" | tee -a "$LOG_FILE"
echo "  nexus-network --help" | tee -a "$LOG_FILE"
echo "  nexus-network start --node-id your-node-id  # Example for starting" | tee -a "$LOG_FILE"
echo "To reinstall, remove $BINARY_PATH and run this script again." | tee -a "$LOG_FILE"
echo "Log saved to: $LOG_FILE" | tee -a "$LOG_FILE"
echo "For updates, check https://github.com/Numiko09/Nexus-aarch64/releases after it is made public." | tee -a "$LOG_FILE"
