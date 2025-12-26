# 🚀 AI Development Stack

> Complete Docker-based AI development environment with ComfyUI, Ollama, n8n, Qdrant, and PostgreSQL

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue)](https://github.com/yourusername/ai-dev-stack-docker)
[![Docker](https://img.shields.io/badge/docker-required-2496ED?logo=docker)](https://www.docker.com/)

One-command installation of a complete AI development environment with image generation, local LLMs, workflow automation, and vector storage.

## ✨ Features

| Service | Port | Description |
|---------|------|-------------|
| **ComfyUI** | 8188 | Stable Diffusion GUI for AI image generation |
| **Ollama** | 11434 | Local LLM server (includes phi4:latest) |
| **n8n** | 5678 | Workflow automation platform |
| **Qdrant** | 6333 | Vector database for embeddings |
| **PostgreSQL** | Internal | Database backend for n8n |

### 🎯 Why This Stack?

- ✅ **Complete AI Toolkit** - Everything you need for AI development in one package
- ✅ **Privacy First** - All models and data stay on your machine
- ✅ **Cross-Platform** - Works on Windows, Linux, and macOS
- ✅ **GPU Support** - Automatic NVIDIA GPU detection and acceleration
- ✅ **Production Ready** - Used for real AI automation workflows
- ✅ **Easy Updates** - One command to update all services

## 🚀 Quick Start

### Windows
```powershell
# Open PowerShell as Administrator
.\install-windows.ps1
```

### Linux/macOS
```bash
chmod +x install-linux-macos.sh
./install-linux-macos.sh
```

**That's it!** The installer will:
1. Check prerequisites (Docker, RAM, disk space)
2. Detect GPU availability
3. Download all images (~10-15GB)
4. Start all services
5. Optionally download phi4:latest model (~8GB)

**Total time:** 20-30 minutes (depending on internet speed)

## 📋 Prerequisites

- **RAM:** 16GB+ recommended (32GB+ ideal)
- **Disk Space:** 30GB+ free
- **Docker:** Docker Desktop (Windows/macOS) or Docker Engine (Linux)
- **GPU (Optional):** NVIDIA GPU with drivers for acceleration

## 📚 Documentation

- **[Quick Start Guide](QUICKSTART.md)** - Get running in 5 minutes
- **[Complete Documentation](README.md)** - Detailed setup and configuration
- **[n8n Workflow Guide](N8N-WORKFLOW-GUIDE.md)** - Build AI automation workflows
- **[Contributing](CONTRIBUTING.md)** - How to contribute

## 🎨 What Can You Build?

### AI Image Generator
Generate images with natural language:
```
"Generate a photorealistic portrait of a woman at sunset"
"Create a cartoon-style dragon breathing fire"
"Make a 1024x1024 landscape painting of mountains"
```

### Intelligent Chatbot
Local AI chat with phi4:
```python
# Fully private, no cloud API needed
docker exec -it ollama ollama run phi4:latest
```

### Automated Workflows
Build with n8n:
- Auto-generate social media posts with images
- Analyze documents and create summaries
- Build custom AI agents
- Create image galleries from text descriptions

## 🖼️ Screenshots

### ComfyUI Interface
Access at http://localhost:8188
- Visual node-based interface
- Real-time image generation
- Custom workflows

### n8n Automation
Access at http://localhost:5678
- Drag-and-drop workflow builder
- Connect all AI services
- Schedule automations

### Ollama Chat
Local LLM with 14B parameters:
```bash
docker exec -it ollama ollama run phi4:latest
```

## 🛠️ Management

```bash
# Navigate to installation directory
cd ~/ai-dev-stack  # or %USERPROFILE%\ai-dev-stack on Windows

# Start services
docker compose up -d

# Stop services
docker compose down

# View logs
docker compose logs -f

# Check status
docker compose ps

# Update images
docker compose pull && docker compose up -d
```

**Or use the interactive management tool:**
- **Windows:** Double-click `manage.bat`
- **Linux/macOS:** `./manage.sh`

## 🤖 Available Models

### Ollama (LLMs)
```bash
# Included with installer
phi4:latest (14B, ~8GB) - Microsoft's latest, excellent quality

# Popular alternatives
docker exec -it ollama ollama pull llama3.2       # Fast, 3B
docker exec -it ollama ollama pull qwen2.5-coder  # Best for code, 7B
docker exec -it ollama ollama pull mistral        # High quality, 7B
```

### ComfyUI (Image Models)
Download Stable Diffusion models from:
- [Civitai](https://civitai.com) - Largest community repository
- [Hugging Face](https://huggingface.co) - Official models
- [Stability AI](https://stability.ai) - Original SD models

Place in: `comfyui/models/checkpoints/`

## 🔧 Advanced Configuration

### GPU Support
- **Windows:** Automatic with Docker Desktop + NVIDIA drivers
- **Linux:** Install nvidia-docker2
```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```
- **macOS:** Not supported (CPU only)

### Custom Ports
Edit `docker-compose.yml` to change ports:
```yaml
ports:
  - "8188:8188"  # Change left number for custom port
```

### Resource Limits
Add to services in `docker-compose.yml`:
```yaml
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 8G
```

## 📊 System Requirements by Use Case

| Use Case | RAM | GPU | Disk |
|----------|-----|-----|------|
| Chatbot only | 8GB | Optional | 15GB |
| Image generation | 16GB | Recommended | 25GB |
| Full stack | 32GB+ | Recommended | 50GB+ |
| Production | 64GB+ | Required | 100GB+ |

## 🤝 Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Ways to Contribute
- 🐛 Report bugs
- 💡 Suggest features
- 📝 Improve documentation
- 🔧 Submit pull requests
- 🎨 Share workflow templates

## 🆘 Getting Help

1. **Check the docs** - Most issues are covered in the guides
2. **Search issues** - Someone may have had the same problem
3. **Create an issue** - Provide OS, Docker version, and error logs
4. **Join community** - Links in [discussions](../../discussions)

## 📝 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

Individual services (ComfyUI, Ollama, n8n, etc.) have their own licenses.

## 🌟 Star History

If this project helps you, please give it a ⭐️! It helps others discover it.

## 📢 Acknowledgments

This stack builds on amazing open source projects:
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - Powerful Stable Diffusion GUI
- [Ollama](https://ollama.com) - Easy local LLM deployment
- [n8n](https://n8n.io) - Workflow automation
- [Qdrant](https://qdrant.tech) - Vector search engine
- [PostgreSQL](https://www.postgresql.org) - Reliable database

## 🔗 Links

- **Documentation:** See docs in repository
- **Issues:** [GitHub Issues](../../issues)
- **Discussions:** [GitHub Discussions](../../discussions)
- **Latest Release:** [Releases](../../releases)

---

**Built with ❤️ by the AI Development Community**

[⬆ Back to top](#-ai-development-stack)
