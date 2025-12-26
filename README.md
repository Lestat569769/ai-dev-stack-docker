# AI Development Stack - Cross-Platform Installation

Complete Docker-based AI development environment with ComfyUI (Stable Diffusion), Ollama (LLMs), n8n (Automation), Qdrant (Vector DB), and PostgreSQL.

## 🚀 What's Included

| Service | Port | Description |
|---------|------|-------------|
| **ComfyUI** | 8188 | Stable Diffusion GUI for image generation |
| **Ollama** | 11434 | Local LLM server (includes phi4:latest) |
| **n8n** | 5678 | Workflow automation platform |
| **Qdrant** | 6333 | Vector database for embeddings |
| **PostgreSQL** | Internal | Database backend for n8n |

### Feature Highlights

**🎨 ComfyUI**
- Node-based visual interface for Stable Diffusion
- Multiple model support (SD 1.5, SDXL, custom)
- ControlNet for precise image control
- Built-in upscaling and enhancement
- Custom nodes and extensions

**🤖 Ollama**
- phi4:latest (14B params) included
- 100% private, no cloud APIs
- GPU acceleration (NVIDIA)
- Multiple model support
- OpenAI-compatible API

**🔄 n8n**
- Visual workflow builder
- 400+ integrations
- AI nodes (Ollama, OpenAI, etc.)
- Scheduled & webhook triggers
- JavaScript/Python code nodes

**📊 Qdrant**
- Fast vector similarity search
- Semantic search capabilities
- Web-based dashboard
- Perfect for RAG applications

**🗄️ PostgreSQL**
- Reliable data persistence
- n8n workflow storage
- Execution history tracking

## 📋 Prerequisites

### All Platforms
- **RAM**: 16GB+ recommended (32GB+ ideal)
- **Disk Space**: 30GB+ free space
- **Docker**: Docker Desktop (Windows/macOS) or Docker Engine (Linux)

### Windows
- Windows 10/11 (64-bit)
- Docker Desktop 4.0+
- PowerShell 5.1+ (comes with Windows)
- Administrator privileges

### Linux
- Ubuntu 20.04+, Debian 11+, or similar
- Docker Engine 24.0+
- Docker Compose V2
- curl, git

### macOS
- macOS 12 (Monterey) or newer
- Docker Desktop 4.0+
- bash, curl

### GPU Support (Optional but Recommended)
- **NVIDIA GPU** with CUDA support
- **Linux**: NVIDIA drivers + nvidia-docker2
- **Windows**: NVIDIA drivers (Docker Desktop handles GPU passthrough)
- **macOS**: GPU acceleration not supported in Docker

## 🔧 Installation

### Windows

1. **Open PowerShell as Administrator**
   ```powershell
   # Right-click PowerShell → "Run as Administrator"
   ```

2. **Navigate to installation directory**
   ```powershell
   cd $HOME\Downloads
   ```

3. **Run the installer**
   ```powershell
   .\install-windows.ps1
   ```

4. **Follow the prompts**
   - The script will check prerequisites
   - Download all required images (~10-15GB)
   - Start all services
   - Optionally download phi4 model (~8GB)

**Estimated time**: 20-30 minutes (depending on internet speed)

### Linux

1. **Download the installer**
   ```bash
   cd ~
   curl -O https://raw.githubusercontent.com/[your-repo]/install-linux-macos.sh
   chmod +x install-linux-macos.sh
   ```

2. **Run the installer**
   ```bash
   ./install-linux-macos.sh
   ```

3. **Follow the prompts**

**Note**: If you don't have Docker installed, the script will provide installation instructions.

### macOS

1. **Ensure Docker Desktop is installed and running**
   ```bash
   docker --version
   ```

2. **Download and run the installer**
   ```bash
   cd ~
   curl -O https://raw.githubusercontent.com/[your-repo]/install-linux-macos.sh
   chmod +x install-linux-macos.sh
   ./install-linux-macos.sh
   ```

## 🎯 Quick Start

### Access the Services

After installation, access these URLs in your browser:

- **ComfyUI**: http://localhost:8188
- **n8n**: http://localhost:5678
- **Ollama API**: http://localhost:11434
- **Qdrant Dashboard**: http://localhost:6333/dashboard

### First Steps

1. **ComfyUI Setup**
   - Open http://localhost:8188
   - Download a Stable Diffusion model from [Civitai](https://civitai.com) or [Hugging Face](https://huggingface.co)
   - Place models in the appropriate folder (see File Locations below)
   - Load a workflow and start generating images!

2. **n8n Setup**
   - Open http://localhost:5678
   - Create your account (local only, no cloud signup)
   - Browse workflow templates at [n8n.io](https://n8n.io)
   - Connect to Ollama for AI-powered automations

3. **Ollama LLM**
   - phi4:latest is included (if you chose to download it)
   - Test it: `docker exec -it ollama ollama run phi4:latest`
   - Install more models: `docker exec -it ollama ollama pull <model-name>`

## 📂 File Locations

### Windows
```
%USERPROFILE%\ai-dev-stack\
├── docker-compose.yml
├── .env
├── comfyui\
│   ├── models\          # Put SD models here
│   ├── input\           # Input images
│   ├── output\          # Generated images
│   └── custom_nodes\    # ComfyUI extensions
└── n8n\
    └── backup\          # n8n workflow backups
```

### Linux/macOS
```
~/ai-dev-stack/
├── docker-compose.yml
├── .env
├── comfyui/
│   ├── models/          # Put SD models here
│   ├── input/           # Input images
│   ├── output/          # Generated images
│   └── custom_nodes/    # ComfyUI extensions
└── n8n/
    └── backup/          # n8n workflow backups
```

## 🛠️ Management Commands

Navigate to your installation directory first:

**Windows**: `cd $HOME\ai-dev-stack`  
**Linux/macOS**: `cd ~/ai-dev-stack`

### Basic Operations

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# Restart a specific service
docker compose restart [service-name]

# View logs
docker compose logs -f [service-name]

# Check service status
docker compose ps
```

### Service Names
- `comfyui` - ComfyUI
- `ollama` - Ollama LLM server
- `n8n` - n8n automation
- `postgres` - PostgreSQL database
- `qdrant` - Qdrant vector database

### Examples

```bash
# View ComfyUI logs
docker compose logs -f comfyui

# Restart Ollama
docker compose restart ollama

# Stop everything
docker compose down

# Start everything
docker compose up -d
```

## 🤖 Ollama Model Management

### List Installed Models
```bash
docker exec -it ollama ollama list
```

### Install New Models

**Recommended models**:
```bash
# phi4 - Microsoft's latest, great quality (14B, ~8GB)
docker exec -it ollama ollama pull phi4:latest

# llama3.2 - Fast, general purpose (3B, ~2GB)
docker exec -it ollama ollama pull llama3.2

# qwen2.5-coder - Excellent for code (7B, ~4.7GB)
docker exec -it ollama ollama pull qwen2.5-coder:latest

# mistral - High quality responses (7B, ~4GB)
docker exec -it ollama ollama pull mistral:latest

# codellama - Code generation (7B, ~4GB)
docker exec -it ollama ollama pull codellama:latest
```

### Test a Model
```bash
docker exec -it ollama ollama run phi4:latest "Hello, how are you?"
```

### Remove a Model
```bash
docker exec -it ollama ollama rm <model-name>
```

## 🎨 ComfyUI Models

### Where to Download Models

1. **[Civitai](https://civitai.com)** - Largest community model repository
2. **[Hugging Face](https://huggingface.co)** - Official and community models
3. **[Stability AI](https://stability.ai)** - Official Stable Diffusion models

### Model Types and Locations

Place downloaded models in the appropriate subfolder:

```
comfyui/models/
├── checkpoints/         # Main SD models (.safetensors, .ckpt)
├── loras/              # LoRA models
├── vae/                # VAE models
├── controlnet/         # ControlNet models
├── upscale_models/     # Upscalers (ESRGAN, etc.)
└── embeddings/         # Textual inversions
```

### Popular Models to Start With

1. **Stable Diffusion XL Base** (6.5GB)
   - General purpose, high quality
   - Download from Hugging Face

2. **Realistic Vision** (2GB)
   - Photorealistic images
   - Available on Civitai

3. **DreamShaper** (2GB)
   - Artistic/creative images
   - Available on Civitai

## 🔄 n8n Workflows

### 🎯 Included Workflow Template: AI Image Generator

This stack includes a **complete, production-ready workflow** that combines Ollama and ComfyUI for intelligent image generation.

#### How It Works

**Basic Flow:**
```
User Message → Detect "image" keyword → Two paths:

Path 1 (Image Generation):
  User Input → Ollama (enhance prompt) → Parse JSON → 
  Build ComfyUI API → Generate Image → Download → Return

Path 2 (Regular Chat):
  User Input → Ollama (chat) → Format → Return
```

**Intelligent Features:**

1. **Style Auto-Detection**
   - Detects cartoon characters (Rick and Morty, SpongeBob, etc.) → Cartoon style
   - Detects "painting", "watercolor" → Artistic style
   - Detects "3d render", "cgi" → 3D style
   - Default for realistic subjects → Photorealistic

2. **Quality Presets**
   - "quick" or "draft" → 20 steps (fast)
   - "normal" → 35 steps (balanced)
   - "high" or "detailed" → 50 steps (quality)
   - "ultra" → 70 steps (maximum quality)

3. **Dimension Detection**
   - "portrait" → 512x768
   - "landscape" → 768x512
   - "1024" → 1024x1024
   - "4k" → 2048x2048
   - "phone" → 480x853

4. **Dual-Mode Operation**
   - Contains "image"? → Generate image with ComfyUI
   - No "image"? → Chat response with Ollama

#### Example Interactions

**Example 1: Simple Request**
```
User: "generate image of a sunset over mountains"
→ Ollama enhances: "RAW photo, professional landscape photography..."
→ ComfyUI generates: Photorealistic landscape (high quality, 35 steps)
→ User receives: Beautiful sunset image with metadata
```

**Example 2: Style Control**
```
User: "generate cartoon image of a friendly dragon"
→ Ollama: "digital illustration, cartoon style, vibrant colors..."
→ ComfyUI: Cartoon sampler (euler), CFG 11.0
→ User receives: Colorful cartoon dragon
```

**Example 3: Quality Control**
```
User: "generate ultra quality 1024 portrait of a woman"
→ Detects: ultra (70 steps), 1024 (1024x1024), portrait
→ Ollama adds: "detailed facial features, professional photography..."
→ ComfyUI generates: High-resolution portrait
→ User receives: Ultra-detailed image (~38 seconds)
```

### Import the Workflow

After installation, find the template at:
- **Windows**: `%USERPROFILE%\ai-dev-stack\n8n\workflows\AI-Image-Generator-Template.json`
- **Linux/macOS**: `~/ai-dev-stack/n8n/workflows/AI-Image-Generator-Template.json`

**To import:**
1. Open n8n at http://localhost:5678
2. Click **"Workflows"** → **"Import from File"**
3. Select the template file
4. Configure Ollama credentials (Base URL: `http://ollama:11434`)
5. Activate and test!

**See detailed workflow guide:** [N8N-WORKFLOW-GUIDE.md](N8N-WORKFLOW-GUIDE.md)

### Connect Ollama to n8n

1. Open n8n at http://localhost:5678
2. Create a new workflow or edit the imported template
3. Add an "Ollama" node
4. Configure:
   - **Base URL**: `http://ollama:11434` (for Docker) or `http://localhost:11434` (if not using Docker networking)
   - **Model**: `phi4:latest` (or your chosen model)
5. Add credentials if prompted (select "Ollama API" and leave URL as default)

### Connect ComfyUI to n8n

1. Add an "HTTP Request" node
2. Configure:
   - **URL**: `http://comfyui:8188/api/prompt` (Docker) or `http://localhost:8188/api/prompt`
   - **Method**: POST
   - **Body**: Your ComfyUI prompt JSON

### Example Workflows

**AI Image Generator with Chat**:
- Trigger → Check if request contains "image" → Ollama (generate prompt) → ComfyUI (generate image) → Send result

**Auto Social Media Posts**:
- Schedule → Ollama (write caption) → ComfyUI (generate image) → Post to social

**Smart Content Creation**:
- Webhook → Ollama (analyze request) → ComfyUI (create visuals) → Store in database

## 🔧 Troubleshooting

### Services Won't Start

**Check Docker is running**:
```bash
docker ps
```

**View service logs**:
```bash
docker compose logs [service-name]
```

**Restart everything**:
```bash
docker compose down
docker compose up -d
```

### ComfyUI Can't Find Models

Make sure models are in the correct location:
- Windows: `%USERPROFILE%\ai-dev-stack\comfyui\models\checkpoints\`
- Linux/macOS: `~/ai-dev-stack/comfyui/models/checkpoints/`

Restart ComfyUI:
```bash
docker compose restart comfyui
```

### Ollama Model Download Fails

Check internet connection and retry:
```bash
docker exec -it ollama ollama pull phi4:latest
```

### Port Already in Use

Check what's using the port (example for 8188):

**Windows**:
```powershell
netstat -ano | findstr :8188
```

**Linux/macOS**:
```bash
lsof -i :8188
```

**Solution**: Stop the conflicting service or change ports in `docker-compose.yml`

### Out of Memory Errors

- Close unnecessary applications
- Reduce number of running models
- Consider upgrading RAM

### GPU Not Detected (Linux)

Install NVIDIA Docker support:
```bash
# Ubuntu/Debian
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

## 💾 Backup and Restore

### Backup All Data

```bash
# Backup volumes
docker compose down
docker run --rm -v ai-dev-stack_comfyui-data:/data -v $(pwd):/backup \
  alpine tar czf /backup/comfyui-backup.tar.gz -C /data .

docker run --rm -v ai-dev-stack_ollama-data:/data -v $(pwd):/backup \
  alpine tar czf /backup/ollama-backup.tar.gz -C /data .

docker run --rm -v ai-dev-stack_n8n-data:/data -v $(pwd):/backup \
  alpine tar czf /backup/n8n-backup.tar.gz -C /data .
```

### Backup n8n Workflows Only

```bash
docker compose exec n8n n8n export:workflow --all --output=/backup/workflows.json
```

### Restore from Backup

```bash
# Stop services
docker compose down

# Restore volumes
docker run --rm -v ai-dev-stack_n8n-data:/data -v $(pwd):/backup \
  alpine sh -c "cd /data && tar xzf /backup/n8n-backup.tar.gz"

# Start services
docker compose up -d
```

## 🔒 Security Considerations

### Production Deployment

If deploying to a server or exposing to the internet:

1. **Change default passwords** in `.env`
2. **Use reverse proxy** (nginx, Caddy) with HTTPS
3. **Implement authentication** on all services
4. **Use firewall rules** to restrict access
5. **Regular backups** of data volumes
6. **Keep Docker images updated**

### Environment Variables

Never commit `.env` to git:
```bash
echo ".env" >> .gitignore
```

## 🚀 Advanced Configuration

### Custom Docker Compose Settings

Edit `docker-compose.yml` to:
- Change ports
- Add environment variables
- Adjust resource limits
- Add additional services

### Resource Limits

Add to services in `docker-compose.yml`:
```yaml
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 8G
    reservations:
      memory: 4G
```

### Network Configuration

All services communicate on the `ai-network` bridge network. They can reach each other using container names:
- `http://ollama:11434`
- `http://comfyui:8188`
- `http://qdrant:6333`

## 📚 Additional Resources

### Documentation
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - Official repo and docs
- [Ollama](https://ollama.com/library) - Model library and API docs
- [n8n](https://docs.n8n.io/) - Workflow automation docs
- [Qdrant](https://qdrant.tech/documentation/) - Vector database docs

### Community
- [ComfyUI Discord](https://discord.gg/comfyui)
- [Ollama Discord](https://discord.gg/ollama)
- [n8n Community](https://community.n8n.io/)

### Tutorials
- [ComfyUI Workflows](https://comfyworkflows.com/)
- [n8n Template Library](https://n8n.io/workflows/)
- [Stable Diffusion Guide](https://stable-diffusion-art.com/)

## 🆘 Getting Help

1. **Check logs**: `docker compose logs -f [service-name]`
2. **Verify status**: `docker compose ps`
3. **Search issues**: Check GitHub issues for each service
4. **Community forums**: Discord servers and forums
5. **Update images**: `docker compose pull && docker compose up -d`

## 🗑️ Complete Uninstallation

To completely remove everything:

```bash
# Navigate to install directory
cd ~/ai-dev-stack  # or %USERPROFILE%\ai-dev-stack on Windows

# Stop and remove containers, networks, volumes
docker compose down -v

# Remove installation directory
cd ..
rm -rf ai-dev-stack  # or Remove-Item -Recurse -Force ai-dev-stack on Windows

# Optional: Remove downloaded Docker images
docker image rm yanwk/comfyui-boot:latest
docker image rm ollama/ollama:latest
docker image rm n8nio/n8n:latest
docker image rm qdrant/qdrant:latest
docker image rm postgres:16-alpine
```

## 📝 License

This installation script and configuration is provided as-is. Individual services (ComfyUI, Ollama, n8n, etc.) have their own licenses.

## 🤝 Contributing

Improvements welcome! Feel free to submit issues or pull requests.

---

**Happy Creating! 🎨🤖🚀**
