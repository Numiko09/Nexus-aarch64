# Cross-Compilation Guide for nexus-cli v0.10.13 on aarch64-linux-android

This guide outlines the steps to cross-compile the `nexus-cli` (version 0.10.13) for the `aarch64-linux-android` target on a Linux host (tested on Ubuntu). The resulting binary is suitable for Android devices with ARM64 architecture (API level 30). This process uses Rust nightly, Android NDK r26c, and specific linker configurations to address dependencies like `ring`.

## Prerequisites

1. **System Requirements**:
   - Linux host (e.g., Ubuntu 20.04 or later).
   - At least 4 GB of RAM and 10 GB of free disk space.

2. **Software**:
   - **Rust Nightly**: Install via `rustup`:
     ```bash
     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
     rustup install nightly
     rustup default nightly
     rustup target add aarch64-linux-android
     ```
   - **Android NDK r26c**: Download from [Android NDK Downloads](https://developer.android.com/ndk/downloads) or via Android Studio SDK Manager. Install to `~/Android/Sdk/ndk/android-ndk-r26c`.
   - **Git**: For cloning the repository:
     ```bash
     sudo apt update && sudo apt install git
     ```

3. **Directory Setup**:
   Clone the `nexus-cli` repository (or your fork):
   ```bash
   git clone https://github.com/nexus-xyz/nexus-cli.git ~/test1/nexus-cli
   cd ~/test1/nexus-cli
   ```

## Step-by-Step Compilation

### 1. Update to Version 0.10.13
Ensure you're on the correct release tag:
```bash
git fetch --tags
git checkout v0.10.13
```
Verify the tag:
```bash
git tag -l | grep v0.10.13
```

If the tag is missing, ensure the upstream repository is added:
```bash
git remote add upstream https://github.com/nexus-xyz/nexus-cli.git
git fetch upstream --tags
```

### 2. Configure Android NDK Environment
Set up environment variables for the Android NDK (r26c) to ensure the correct Clang compiler and linker are used:
```bash
export ANDROID_NDK_HOME=~/Android/Sdk/ndk/android-ndk-r26c
export CC=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang
export TARGET_CC=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang
export AR=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ar
export CFLAGS="-march=armv8-a"
export LDFLAGS="-L$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/lib"
```

Verify the compiler exists:
```bash
ls -l $CC
```
If `aarch64-linux-android30-clang` is missing, check available API levels:
```bash
ls $ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android*
```
Update `CC` and `TARGET_CC` to match an available version (e.g., `aarch64-linux-android29-clang`).

### 3. Configure Cargo for Cross-Compilation
Create or edit the Cargo configuration file to specify the linker and archiver for `aarch64-linux-android`:
```bash
mkdir -p ~/test1/nexus-cli/clients/cli/.cargo
nano ~/test1/nexus-cli/clients/cli/.cargo/config.toml
```

Add the following content:
```toml
[target.aarch64-linux-android]
linker = "/home/vboxuser/Android/Sdk/ndk/android-ndk-r26c/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang"
ar = "/home/vboxuser/Android/Sdk/ndk/android-ndk-r26c/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ar"
```

Replace `/home/vboxuser` with your actual home directory path (`echo $HOME`). If using a different API level, update the `linker` path accordingly.

### 4. Build the Binary
Navigate to the CLI directory:
```bash
cd ~/test1/nexus-cli/clients/cli
```

Clean any previous build artifacts:
```bash
cargo clean
```

Build the release binary:
```bash
cargo build --target aarch64-linux-android --release
```

The binary will be generated in:
```bash
~/test1/nexus-cli/clients/cli/target/aarch64-linux-android/release/
```

Check for the binary (it may be named `cli` or `nexus-cli` depending on `Cargo.toml`):
```bash
ls -lh target/aarch64-linux-android/release/
```

If the binary is named `cli`, rename it for consistency:
```bash
mv target/aarch64-linux-android/release/cli target/aarch64-linux-android/release/nexus-cli
```

### 5. Verify the Binary
Ensure the binary is executable and built correctly:
```bash
file target/aarch64-linux-android/release/nexus-cli
```
This should confirm it’s an `aarch64` executable. You can also test the CLI (on an Android device or emulator):
```bash
./target/aarch64-linux-android/release/nexus-cli --help
```

### 6. Package and Publish (Optional)
To include the binary in your GitHub repository (e.g., `Numiko09/Nexus-aarch64`):
```bash
mkdir -p binaries
cp target/aarch64-linux-android/release/nexus-cli binaries/nexus-cli-aarch64
git add binaries/nexus-cli-aarch64
git commit -m "Add aarch64 binary for nexus-cli v0.10.13"
git push origin main
```

Create a new release (e.g., v0.1.1) via the GitHub UI, attaching `binaries/nexus-cli-aarch64`.

## Troubleshooting

1. **Error: `failed to find tool "aarch64-linux-android-clang"`**:
   - Verify `$ANDROID_NDK_HOME` and `$CC` paths.
   - Check available Clang versions:
     ```bash
     ls $ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android*
     ```
   - Update `CC`, `TARGET_CC`, and `.cargo/config.toml` to match an existing version.
   - Reinstall NDK r26c if files are missing.

2. **Binary Not Found**:
   - Check `Cargo.toml` for the `[[bin]]` section:
     ```bash
     cat ~/test1/nexus-cli/clients/cli/Cargo.toml
     ```
     Ensure it contains:
     ```toml
     [[bin]]
     name = "nexus-cli"  # Or "cli"
     path = "src/main.rs"
     ```
   - If the binary is named differently (e.g., `cli`), use:
     ```bash
     cargo build --target aarch64-linux-android --release --bin cli
     ```

3. **Dependency Issues (e.g., `ring`)**:
   - Set `RING_PREGENERATE_ASM=1` to bypass assembly generation:
     ```bash
     export RING_PREGENERATE_ASM=1
     ```
   - Run with verbose output for debugging:
     ```bash
     cargo build --target aarch64-linux-android --release --verbose
     ```

4. **Other Errors**:
   - Ensure Rust nightly is active: `rustup default nightly`.
   - Update dependencies: `cargo update`.
   - If errors persist, capture the full log and seek help in the project’s GitHub issues or community.

## Notes
- This guide assumes Android NDK r26c and API level 30. Adjust paths for other NDK versions or API levels as needed.
- The binary is built without additional features like `--max-threads` to match the vanilla `nexus-cli` v0.10.13.
- For contributions, ensure compliance with the `nexus-cli` license (Apache-2.0/MIT) and include this guide in your fork.

---

### Размещение в GitHub
1. Создай файл `CROSS_COMPILATION.md` в корне `Numiko09/Nexus-aarch64`:
   ```bash
   nano ~/test1/nexus-cli/CROSS_COMPILATION.md
   ```
   Вставь текст выше.

2. Добавь и закоммить:
   ```bash
   git add CROSS_COMPILATION.md
   git commit -m "Add cross-compilation guide for aarch64"
   git push origin main
   ```

3. Если бинарник уже готов, добавь его в `binaries/` (как описано в шаге 6) и создай релиз.

Если что-то нужно уточнить или добавить в инструкцию (например, специфичные для твоего форка детали), напиши! Также, если бинарник всё ещё не найден (после проверки `ls -lh target/aarch64-linux-android/release/`), скинь вывод, и я помогу разобраться.
