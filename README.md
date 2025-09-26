# Nexus-aarch64

This repository provides a precompiled `nexus-network` binary for ARM64 Android devices, cross-compiled from the [nexus-cli](https://github.com/nexus-xyz/nexus-cli) project (version 0.10.13). It is designed to run in Termux on Android 11+ with aarch64 architecture.

## Gratitude

Great thanks to Vau for his invaluable help for making this release happens and for making it looks as it should be. Appreciate mate!

## Requirements

Termux installed on an Android device (ARM64, Android 11+).

Note that Termux from Google Play are no longer supported by developers. 

Use version from https://f-droid.org/en/packages/com.termux/

Internet connection for downloading the binary. 

`curl` (installed automatically by the script).

# Warning

It`s a custom binary for Android devices. It is strongly NOT reccomended to run Cli node on your mobile device due to overheating and probably damage/cause fire. By using this build, you act at your own risk and take full responsibility for any problems and consequences.
## Installation in Termux

### Quick Install

To download and install the `nexus-network` binary in Termux, run the following command:

```bash
curl -sSL -L raw.githubusercontent.com/Numiko09/Nexus-aarch64/main/nexus-termux.sh | bash
```
This will:

Download the precompiled nexus-network binary from the main branch (binaries/nexus-network).
Verify its SHA256 checksum for security.
Install it to /data/data/com.termux/files/usr/bin/nexus-network.
Test the binary with nexus-network --help.

### Manual Install

Download `curl` if not installed:
```bash
pkg install curl -y
```

Download the installation script:
```bash
curl -L raw.githubusercontent.com/Numiko09/Nexus-aarch64/main/nexus-termux.sh
```

Run the installation script:
```bash
chmod +x nexus-termux.sh
./nexus-termux.sh
source ~/.bashrc
```

## Proving

To start with an existing node ID, run:
```bash
nexus-network start --node-id <your-node-id>
```

Alternatively, you can register your wallet address and create a node ID with the CLI, or at app.nexus.xyz.
```bash
nexus-network register-user --wallet-address <your-wallet-address>
nexus-network register-node --node-id <your-cli-node-id>
nexus-network start
```

To run the CLI noninteractively, you can also opt to start it in headless mode.
```bash
nexus-network start --headless
```

### Quick Reference
The register-user and register-node commands will save your credentials to ~/.nexus/config.json. To clear credentials, run:
```bash
nexus-network logout
```
For troubleshooting or to see available command-line options, run:
```bash
nexus-network --help
```
## Adaptive Task Difficulty
The Nexus CLI features an adaptive difficulty system that automatically adjusts task difficulty based on your node's performance. This ensures optimal resource utilization while preventing system overload.

### How It Works
Starts at: small difficulty
Auto-promotes: If tasks complete in < 7 minutes

### When to Override Difficulty
### Lower Difficulty (e.g. Small or SmallMedium):

Resource-constrained systems
Background processing alongside other apps
Testing/development environments
Battery-powered devices

### Higher Difficulty (e.g. Large, ExtraLarge, or ExtraLarge2):

High-performance hardware (8+ cores, 16+ GB RAM)
Dedicated proving machines
Maximum reward optimization
# Using Difficulty Override

## Lower difficulty for resource-constrained systems
```bash
nexus-network start --max-difficulty small
nexus-network start --max-difficulty small_medium
```

## Higher difficulty for powerful hardware
```bash
nexus-network start --max-difficulty medium
nexus-network start --max-difficulty large
nexus-network start --max-difficulty extra_large
nexus-network start --max-difficulty extra_large_2
```

## Case-insensitive (all equivalent)
```bash
nexus-network start --max-difficulty MEDIUM
nexus-network start --max-difficulty medium
nexus-network start --max-difficulty Medium
```

## Tip: Its strongly reccomended to NOT go further medium difficulty on mobile device due to heavy overheating.

# Troubleshooting Difficulty Issues
## Tasks taking too long:

Try a lower difficulty.
```bash
nexus-network start --max-difficulty small_medium
```

## Want more challenging tasks:

Request a harder difficulty. It will still take time to build up reputation to get the requested difficulty.
```bash
nexus-network start --max-difficulty medium
```

## Unsure about system capabilities:

Use the default adaptive system (no --max-difficulty needed).
The system will automatically find the optimal difficulty for your hardware.
Only override if you're fine-tuning performance.

## Building from Source

To cross-compile the binary yourself, follow the guide in CROSS_COMPILATION.md.

## Troubleshooting

### Download failed: 
Ensure the file binaries/nexus-network exists in the main branch at https://github.com/Numiko09/Nexus-aarch64.

### Checksum mismatch: Verify the binary's integrity or redownload.

### Binary not executable: Check permissions (chmod +x) or device compatibility.
Logs: Check ~/nexus-network-install.log for details.

For issues, open a ticket at https://github.com/Numiko09/Nexus-aarch64/issues.

# Contributing
Contributions are welcome! Fork the repository, make changes, and submit a pull request.

## License
Apache-2.0/MIT (same as nexus-cli).
