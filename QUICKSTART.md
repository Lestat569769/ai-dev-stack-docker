# Quick Start Guide - AI Development Stack

## ⚡ Prerequisites Check

Before installing, verify Docker is installed:

```bash
docker --version
```

**✅ See a version number?** Great! Continue below.  
**❌ Command not found?** [Install Docker first →](DOCKER-INSTALLATION.md)

---

## Installation (Choose Your Platform)

### Windows
```powershell
# Open PowerShell as Administrator
.\install-windows.ps1
```

### Linux
```bash
chmod +x install-linux-macos.sh
./install-linux-macos.sh
```

### macOS
```bash
chmod +x install-linux-macos.sh
./install-linux-macos.sh
```

## After Installation

### 1. Access Your Services

Open these in your browser:
- **ComfyUI**: http://localhost:8188
- **n8n**: http://localhost:5678
- **Ollama**: http://localhost:11434
- **Qdrant**: http://localhost:6333/dashboard

### 2. Using the Management Script

**Windows**: Double-click `manage.bat`  
**Linux/macOS**: `./manage.sh`

Or use Docker Compose directly:
```bash
cd ~/ai-dev-stack  # or %USERPROFILE%\ai-dev-stack on Windows

# Start
docker compose up -d

# Stop
docker compose down

# Restart
docker compose restart

# View logs
docker compose logs -f

# Check status
docker compose ps
```

### 3. Download Your First Ollama Model

If you skipped phi4 during installation:
```bash
docker exec -it ollama ollama pull phi4:latest
```

Other recommended models:
```bash
# Fast and small
docker exec -it ollama ollama pull llama3.2

# Best for coding
docker exec -it ollama ollama pull qwen2.5-coder:latest

# High quality responses
docker exec -it ollama ollama pull mistral:latest
```

### 4. Test Ollama

```bash
docker exec -it ollama ollama run phi4:latest "Write a haiku about AI"
```

### 5. Set Up ComfyUI

1. Download a Stable Diffusion model from [Civitai](https://civitai.com)
2. Place it in:
   - **Windows**: `%USERPROFILE%\ai-dev-stack\comfyui\models\checkpoints\`
   - **Linux/macOS**: `~/ai-dev-stack/comfyui/models/checkpoints/`
3. Open http://localhost:8188
4. The model should appear in the model selector

**Recommended starter models:**
- Stable Diffusion XL Base
- Realistic Vision
- DreamShaper

### 6. Set Up n8n

1. Open http://localhost:5678
2. Create your account (local only)
3. **Import the starter workflow**:
   - Click "Workflows" → "Import from File"
   - Select the template from:
     - Windows: `%USERPROFILE%\ai-dev-stack\n8n\workflows\AI-Image-Generator-Template.json`
     - Linux/macOS: `~/ai-dev-stack/n8n/workflows/AI-Image-Generator-Template.json`
4. Configure Ollama credentials:
   - Add an Ollama node
   - Base URL: `http://ollama:11434`
   - Model: `phi4:latest`
5. Test your workflow!

**Full Workflow Example**:
The imported template provides a foundation. You can extend it to:
- Detect when users request images
- Use Ollama to enhance prompts
- Send requests to ComfyUI
- Return generated images in chat

## Common Tasks

### Manage Ollama Models
```bash
# List installed models
docker exec -it ollama ollama list

# Pull a new model
docker exec -it ollama ollama pull <model-name>

# Remove a model
docker exec -it ollama ollama rm <model-name>

# Test a model
docker exec -it ollama ollama run <model-name> "Your prompt"
```

### View Service Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f comfyui
docker compose logs -f ollama
docker compose logs -f n8n
```

### Restart Services
```bash
# All services
docker compose restart

# Specific service
docker compose restart ollama
```

### Update Everything
```bash
docker compose pull
docker compose up -d
```

## File Locations

### Windows
- **Installation**: `%USERPROFILE%\ai-dev-stack`
- **ComfyUI Models**: `%USERPROFILE%\ai-dev-stack\comfyui\models`
- **ComfyUI Output**: `%USERPROFILE%\ai-dev-stack\comfyui\output`

### Linux/macOS
- **Installation**: `~/ai-dev-stack`
- **ComfyUI Models**: `~/ai-dev-stack/comfyui/models`
- **ComfyUI Output**: `~/ai-dev-stack/comfyui/output`

## Troubleshooting

### Services won't start
```bash
# Check Docker is running
docker ps

# View errors
docker compose logs

# Restart everything
docker compose down
docker compose up -d
```

### Port conflicts
Edit `docker-compose.yml` and change the port numbers

### Out of memory
- Close unnecessary applications
- Reduce number of AI models loaded
- Consider using smaller models

## Getting Help

1. Check the full README.md
2. View logs: `docker compose logs -f [service-name]`
3. Check Docker Desktop for issues
4. Visit service documentation:
   - ComfyUI: https://github.com/comfyanonymous/ComfyUI
   - Ollama: https://ollama.com
   - n8n: https://docs.n8n.io

## Next Steps

1. ✅ Services running
2. ✅ Models downloaded
3. 📖 Explore the full README.md
4. 🎨 Generate your first image in ComfyUI
5. 🤖 Chat with Ollama models
6. 🔄 Build automations in n8n
7. 🚀 Create AI-powered workflows!

---

**Need more details?** Check the full `README.md` file!
