# 🐳 Docker Installation Guide

This guide covers Docker installation for Windows, Linux, and macOS.

## Quick Check: Is Docker Already Installed?

Open a terminal/command prompt and run:
```bash
docker --version
```

If you see a version number, Docker is installed! ✅ You can skip to the [main installation guide](README.md).

If you get "command not found" or similar error, follow the instructions below for your operating system.

---

## 🪟 Windows Installation

### System Requirements
- **Windows 10/11** (64-bit)
- **WSL 2** (Windows Subsystem for Linux 2)
- **Virtualization** enabled in BIOS
- **4GB RAM minimum** (8GB+ recommended)

### Step 1: Enable WSL 2

1. **Open PowerShell as Administrator**
   - Press `Windows + X`
   - Click "Windows PowerShell (Admin)" or "Terminal (Admin)"

2. **Enable WSL:**
   ```powershell
   wsl --install
   ```

3. **Restart your computer** when prompted

4. **Verify WSL 2:**
   ```powershell
   wsl --list --verbose
   ```

### Step 2: Install Docker Desktop

1. **Download Docker Desktop:**
   - Visit: https://www.docker.com/products/docker-desktop
   - Click "Download for Windows"

2. **Run the installer:**
   - Double-click `Docker Desktop Installer.exe`
   - Follow the installation wizard
   - ✅ Check "Use WSL 2 instead of Hyper-V" (recommended)
   - ✅ Check "Add shortcut to desktop"

3. **Complete installation:**
   - Click "Close and restart" when prompted
   - Computer will restart

4. **Start Docker Desktop:**
   - Launch Docker Desktop from Start Menu
   - Accept the service agreement
   - You may be asked to sign in (optional, can skip)

5. **Verify installation:**
   ```powershell
   docker --version
   docker compose version
   ```

   You should see:
   ```
   Docker version 24.x.x
   Docker Compose version v2.x.x
   ```

### Troubleshooting Windows

**Problem: "WSL 2 installation is incomplete"**
```powershell
# Update WSL
wsl --update

# Set WSL 2 as default
wsl --set-default-version 2
```

**Problem: "Virtualization is not enabled"**
1. Restart computer
2. Enter BIOS (usually F2, F10, Del, or Esc during boot)
3. Find "Virtualization Technology" or "Intel VT-x" or "AMD-V"
4. Enable it
5. Save and exit BIOS

**Problem: Docker Desktop won't start**
1. Open Task Manager (Ctrl+Shift+Esc)
2. End all Docker processes
3. Restart Docker Desktop
4. If still failing, reinstall Docker Desktop

---

## 🐧 Linux Installation

### Ubuntu / Debian

**Step 1: Remove old versions (if any)**
```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```

**Step 2: Install prerequisites**
```bash
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

**Step 3: Add Docker's official GPG key**
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

**Step 4: Set up the repository**
```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

**Step 5: Install Docker Engine**
```bash
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Step 6: Add your user to docker group (avoid using sudo)**
```bash
sudo usermod -aG docker $USER
```

**Step 7: Log out and log back in** (or run):
```bash
newgrp docker
```

**Step 8: Verify installation**
```bash
docker --version
docker compose version
docker run hello-world
```

**Step 9: Enable Docker to start on boot**
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

### Fedora / CentOS / RHEL

**Step 1: Remove old versions**
```bash
sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine
```

**Step 2: Install prerequisites**
```bash
sudo dnf -y install dnf-plugins-core
```

**Step 3: Add Docker repository**
```bash
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
```

**Step 4: Install Docker**
```bash
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Step 5: Start Docker**
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

**Step 6: Add user to docker group**
```bash
sudo usermod -aG docker $USER
newgrp docker
```

**Step 7: Verify**
```bash
docker --version
docker run hello-world
```

### Arch Linux

```bash
# Install Docker
sudo pacman -S docker docker-compose

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker --version
```

### Troubleshooting Linux

**Problem: "permission denied" when running docker**
```bash
# Add yourself to docker group
sudo usermod -aG docker $USER

# Refresh group membership
newgrp docker

# Or log out and log back in
```

**Problem: Docker daemon won't start**
```bash
# Check status
sudo systemctl status docker

# View logs
sudo journalctl -u docker

# Restart Docker
sudo systemctl restart docker
```

**Problem: "Cannot connect to Docker daemon"**
```bash
# Start Docker daemon
sudo systemctl start docker

# Enable on boot
sudo systemctl enable docker
```

---

## 🍎 macOS Installation

### System Requirements
- **macOS 11 (Big Sur) or newer**
- **4GB RAM minimum** (8GB+ recommended)
- **Apple Silicon (M1/M2/M3)** or **Intel processor**

### Installation Steps

**Step 1: Download Docker Desktop**
1. Visit: https://www.docker.com/products/docker-desktop
2. Click "Download for Mac"
3. Choose:
   - **Apple Silicon** (M1/M2/M3 Macs)
   - **Intel Chip** (older Macs)

**Step 2: Install Docker Desktop**
1. Open the downloaded `.dmg` file
2. Drag Docker icon to Applications folder
3. Open Applications folder
4. Double-click Docker to launch

**Step 3: Complete setup**
1. Docker will ask for permissions
2. Enter your Mac password when prompted
3. Accept the service agreement
4. You may be asked to sign in (optional, can skip)

**Step 4: Verify installation**
```bash
docker --version
docker compose version
docker run hello-world
```

### Troubleshooting macOS

**Problem: "Docker Desktop requires macOS 11 or newer"**
- Upgrade your macOS to Big Sur or newer
- Or use Docker Toolbox for older macOS (not recommended)

**Problem: Docker uses too much CPU/memory**
1. Click Docker icon in menu bar
2. Go to Preferences → Resources
3. Adjust CPU and Memory limits
4. Click "Apply & Restart"

**Problem: "Cannot connect to Docker daemon"**
1. Make sure Docker Desktop is running (check menu bar)
2. Restart Docker Desktop
3. Restart your Mac if needed

---

## 🔧 Post-Installation: GPU Support (Optional)

### For NVIDIA GPUs (Linux only)

Docker Desktop on Windows and macOS handles GPU automatically. For Linux:

**Step 1: Install NVIDIA drivers**
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y nvidia-driver-535  # or latest version

# Verify
nvidia-smi
```

**Step 2: Install NVIDIA Container Toolkit**
```bash
# Add repository
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# Install
sudo apt-get update
sudo apt-get install -y nvidia-docker2

# Restart Docker
sudo systemctl restart docker
```

**Step 3: Test GPU access**
```bash
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

You should see your GPU information! ✅

---

## ✅ Verification Checklist

Before proceeding with the AI stack installation, verify:

- [ ] `docker --version` shows version 24.0 or newer
- [ ] `docker compose version` shows version 2.0 or newer
- [ ] `docker run hello-world` completes successfully
- [ ] Docker Desktop is running (Windows/Mac) or daemon is active (Linux)
- [ ] You can run docker commands without `sudo` (Linux)
- [ ] (Optional) GPU is accessible: `docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi`

---

## 🚀 Next Steps

Docker is installed! Now you can proceed with the AI Development Stack:

### Windows
```powershell
.\install-windows.ps1
```

### Linux/macOS
```bash
chmod +x install-linux-macos.sh
./install-linux-macos.sh
```

---

## 📚 Additional Resources

### Official Documentation
- [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)
- [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
- [Docker Engine for Linux](https://docs.docker.com/engine/install/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

### Learning Docker
- [Docker Getting Started](https://docs.docker.com/get-started/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

### Troubleshooting
- [Docker Desktop Troubleshooting](https://docs.docker.com/desktop/troubleshoot/overview/)
- [Linux Post-Installation Steps](https://docs.docker.com/engine/install/linux-postinstall/)

---

## ❓ Common Questions

**Q: Do I need Docker Desktop or Docker Engine?**
A: 
- **Windows/Mac**: Use Docker Desktop (includes GUI)
- **Linux**: Use Docker Engine (command-line) OR Docker Desktop (with GUI)

**Q: Can I use Podman instead of Docker?**
A: Not recommended. This stack is tested with Docker. Podman may work but is unsupported.

**Q: How much disk space does Docker need?**
A: 
- Docker itself: ~500MB
- AI Development Stack images: ~15GB
- Total recommended: 30GB+ free space

**Q: Is Docker free?**
A: Yes! Docker Desktop is free for personal use and small businesses. Large enterprises need a paid license.

**Q: Do I need an internet connection?**
A: 
- For installation: Yes (to download Docker and images)
- After installation: No (everything runs locally)

**Q: Will Docker slow down my computer?**
A: Docker uses resources only when containers are running. You can adjust CPU/memory limits in Docker Desktop settings.

---

**Need help?** Open an issue on the [repository](https://github.com/Lestat569769/ai-dev-stack-docker/issues).

**Ready to continue?** Go back to the [main README](README.md) or [Quick Start Guide](QUICKSTART.md).
