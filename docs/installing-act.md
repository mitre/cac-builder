# Installing Act for Local GitHub Actions Testing

[Act](https://github.com/nektos/act) is a tool that allows you to run GitHub Actions workflows locally. This guide covers how to install and configure Act on different platforms.

## Installation Options

### macOS

Using Homebrew:

```bash
brew install act
```

Act will automatically use Docker Desktop on macOS. Make sure Docker Desktop is:

1. Installed ([Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/))
2. Running before using Act
3. Allocated sufficient resources (Memory: 4GB+ recommended)

### Linux

#### Ubuntu/Debian

Using the installation script:

```bash
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

Or manually:

```bash
# Download the latest release
curl -s https://api.github.com/repos/nektos/act/releases/latest | \
  grep browser_download_url | \
  grep Linux_x86_64 | \
  cut -d '"' -f 4 | \
  wget -i - -O act.tar.gz

# Extract the binary
tar -xzf act.tar.gz act
chmod +x act

# Move to a directory in your PATH
sudo mv act /usr/local/bin/
rm act.tar.gz
```

#### Fedora/RHEL/CentOS

Using DNF:

```bash
sudo dnf install act
```

#### Arch Linux

Using pacman or yay:

```bash
yay -S act
```

### Windows

#### Using Chocolatey

```powershell
choco install act-cli
```

#### Using Scoop

```powershell
scoop install act
```

#### Manual Installation

1. Download the latest Windows release from [GitHub Releases](https://github.com/nektos/act/releases)
2. Extract the zip file
3. Add the extracted directory to your PATH

## Verification

After installation, verify Act is properly installed:

```bash
act --version
```

You should see output showing the installed version of Act.

## Configuration

Create a `.actrc` file in your project root to configure Act:

```bash
# Example .actrc
-P ubuntu-latest=catthehacker/ubuntu:act-latest
-P ubuntu-22.04=catthehacker/ubuntu:act-22.04
--artifact-server-path=/tmp/artifacts
```

Or use our provided `.github/workflows/.actrc` file, which is set up with recommended configurations.

## Requirements

Act requires:

1. Docker installed and running
2. Sufficient disk space for container images
3. GitHub repository structure with workflows in `.github/workflows/`

## Troubleshooting

### Docker Issues

If you encounter Docker-related errors:

- Ensure Docker is running: `docker info`
- Check Docker permissions: Try running Act with `sudo` or add your user to the Docker group

### Memory Issues

For large workflows that crash:

```bash
act -s GITHUB_TOKEN=<your-token> --job build --container-options="-m 4g"
```

### Missing Secrets

If your workflow needs secrets:

```bash
act -s SECRET_NAME=secret_value
```

## Further Resources

- [Act GitHub Repository](https://github.com/nektos/act)
- [Act Documentation](https://github.com/nektos/act#commands)
- [Using Act in CI](https://github.com/nektos/act#using-act-in-ci)

## Next Steps

After installing Act, see [Local Development](local-development.md) for information on how to use our `test-github-actions.sh` script to test GitHub Actions workflows.

## macOS with Docker Desktop Specific Setup

### Configuring Docker Desktop for Act

For optimal performance with Act on macOS:

1. Open Docker Desktop
2. Go to **Settings** (gear icon)
3. Navigate to **Resources**:
   - Increase **Memory** to at least 4GB
   - Allocate at least 2-4 **CPUs**
   - Set **Swap** to at least 1GB
4. Click **Apply & Restart**

### M-series Chip Considerations

If you're running on an Apple M-series (ARM) chip, you'll need some additional configuration:

1. Specify the architecture when running act:

   ```bash
   # For M-series MacBooks, running ARM architecture
   act --container-architecture linux/arm64
   
   # Or force x86_64 architecture (may be slower but more compatible)
   act --container-architecture linux/amd64
   ```

2. Our test script already has this built in:

   ```bash
   # Run with arm64 architecture
   ./scripts/test-github-actions.sh -a arm64
   ```

### Docker Socket and Permissions

Act requires access to the Docker socket. On macOS, this often requires special handling:

1. **Permission Issues**:

   ```bash
   # If you see permission errors accessing Docker socket
   sudo chmod 666 /var/run/docker.sock
   ```

2. **Socket Location Issues**:
   
   Docker Desktop on macOS uses a different socket location than the default Linux path. If you see socket-related errors, explicitly set the socket path:

   ```bash
   # Find your socket location
   docker context inspect | grep "SocketPath"
   
   # Use that socket path with act
   act --container-daemon-socket /Users/username/Library/Containers/com.docker.docker/Data/docker.sock
   ```

3. **Alternative Docker Socket Approach**:
   
   You can also try mounting the socket directory when running act:

   ```bash
   # Create a directory for the Docker socket if it doesn't exist
   mkdir -p ~/.docker/run
   
   # Run act with a specific socket location
   act --bind -v ~/.docker/run:/var/run
   ```

### Troubleshooting Docker Context

If you're still having socket issues, check your Docker context:

```bash
# List available Docker contexts
docker context ls

# Ensure you're using the desktop-linux context
docker context use desktop-linux
```

### Other macOS Troubleshooting Tips

1. **Performance Issues**:
   - Ensure Docker Desktop has sufficient resources
   - Use the `--cpu-profile-path` flag to identify performance bottlenecks:

     ```bash
     act --cpu-profile-path cpu.prof
     ```

2. **Volume Mounting Issues**:
   - Ensure Docker Desktop has access to the directories you're working with
   - In Docker Desktop settings, check File Sharing / Resources > File sharing
   - Try running with the `-b` flag to bind working directory

3. **Certificate File Access**:
   - Ensure certificate files have proper permissions (readable)
   - When creating files in scripts, use `chmod 644` to ensure they're readable

4. **Simplified Testing**:
   - Use our `-p` (prepare only) flag to just set up the environment without running act:
   
   ```bash
   ./scripts/test-github-actions.sh -w build-test.yml -a arm64 -p
   ```
   
   - This will show you the exact command to run manually
