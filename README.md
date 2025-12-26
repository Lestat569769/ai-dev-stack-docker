# 🚀 AI Development Stack

> Complete Docker-based AI development environment with ComfyUI, Ollama, n8n, Qdrant, and PostgreSQL

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue)](https://github.com/Lestat569769/ai-dev-stack-docker)
[![Docker](https://img.shields.io/badge/docker-required-2496ED?logo=docker)](https://www.docker.com/)

One-command installation of a complete AI development environment with image generation, local LLMs, workflow automation, and vector storage.

## ✨ Features & Services

### 🎨 ComfyUI (Port 8188)
**Advanced Stable Diffusion Interface**

ComfyUI is a powerful node-based interface for Stable Diffusion that allows you to:
- **Generate AI Images** - Create photorealistic, artistic, or stylized images from text prompts
- **Visual Workflow Builder** - Design complex image generation pipelines with a drag-and-drop interface
- **Model Management** - Easily switch between different Stable Diffusion models (SD 1.5, SDXL, custom models)
- **Advanced Controls** - Fine-tune every aspect: steps, CFG scale, samplers, schedulers, seeds
- **ControlNet Support** - Use pose, depth, and edge detection for precise control
- **Upscaling & Enhancement** - Built-in support for image upscaling and refinement
- **Custom Nodes** - Extend functionality with community-created nodes
- **Batch Processing** - Generate multiple variations efficiently

**Use Cases:**
- Create marketing materials and social media content
- Generate concept art and illustrations
- Produce product mockups and visualizations
- Build custom image generation workflows
- Experiment with AI art styles

---

### 🤖 Ollama (Port 11434)
**Local Large Language Model Server**

Ollama makes running large language models locally simple and efficient:
- **phi4:latest Included** - Microsoft's 14B parameter model with excellent quality
- **No Cloud Required** - 100% private, runs entirely on your machine
- **Fast Inference** - Optimized for both CPU and GPU
- **Easy Model Management** - One command to download and switch models
- **OpenAI-Compatible API** - Works with existing tools and libraries
- **Multiple Models** - Run different models for different tasks (chat, code, creative writing)
- **Context Aware** - Maintains conversation context for natural interactions
- **Low Memory Mode** - Intelligent model loading and unloading

**Popular Models Supported:**
- **phi4** (14B) - Best overall quality, recommended
- **llama3.2** (3B) - Fast, great for quick queries
- **qwen2.5-coder** (7B) - Specialized for code generation
- **mistral** (7B) - High quality, multilingual
- **codellama** (7B) - Meta's code-focused model

**Use Cases:**
- Build chatbots and virtual assistants
- Generate code and documentation
- Analyze and summarize documents
- Create content (blogs, emails, social posts)
- Answer questions from your knowledge base
- Power intelligent automation workflows

---

### 🔄 n8n (Port 5678)
**Workflow Automation Platform**

n8n connects all your AI services and automates complex workflows:
- **Visual Workflow Builder** - Drag-and-drop interface for creating automations
- **AI Integration** - Pre-built nodes for Ollama, OpenAI, and more
- **400+ Integrations** - Connect to APIs, databases, cloud services, and local tools
- **Scheduled Execution** - Run workflows on cron schedules or intervals
- **Webhook Support** - Trigger workflows from external services
- **Conditional Logic** - IF/THEN conditions, loops, and branching
- **Data Transformation** - JavaScript/Python code nodes for custom logic
- **Error Handling** - Retry logic, error notifications, and debugging tools
- **Self-Hosted** - Full control over your data and workflows

**Pre-Built Workflow Included:**
This stack includes a complete **AI Image Generator** workflow template that:
- ✅ Detects when users request images vs regular chat
- ✅ Uses Ollama to intelligently enhance prompts
- ✅ Auto-detects style (photorealistic, cartoon, painting, 3D)
- ✅ Sends optimized requests to ComfyUI
- ✅ Monitors generation progress
- ✅ Downloads and returns generated images
- ✅ Provides dual-mode: image generation OR conversational chat

**Use Cases:**
- Automate social media posts with AI-generated images
- Build custom AI agents for specific tasks
- Create data processing pipelines
- Monitor and respond to events automatically
- Integrate AI into existing business processes
- Build internal tools and dashboards

---

### 📊 Qdrant (Port 6333)
**High-Performance Vector Database**

Qdrant stores and searches vector embeddings for semantic search and AI applications:
- **Fast Vector Search** - Millisecond-level similarity search over millions of vectors
- **Multiple Distance Metrics** - Cosine, Euclidean, Dot Product
- **Filtering** - Combine vector search with metadata filters
- **Collections** - Organize vectors into separate namespaces
- **Payloads** - Store additional data with each vector
- **Snapshots** - Backup and restore your data
- **RESTful API** - Easy integration with any language
- **Web Dashboard** - Visual interface for managing collections

**Use Cases:**
- Semantic search over documents
- Image similarity search
- Recommendation systems
- RAG (Retrieval Augmented Generation) for AI
- Chatbots with long-term memory
- Duplicate detection
- Clustering and classification

---

### 🗄️ PostgreSQL (Internal)
**Reliable Database Backend**

PostgreSQL provides persistent storage for n8n and your workflows:
- **Workflow Storage** - All n8n workflows, executions, and credentials
- **Execution History** - Track every workflow run with full logs
- **ACID Compliance** - Reliable, transactional data storage
- **High Performance** - Optimized for n8n's workload
- **Automatic Backups** - Via Docker volumes
- **Secure** - Isolated within Docker network

---

### 🎯 Why This Stack?

**🔒 Privacy First**
- All models and data stay on your machine
- No cloud API calls required
- Full control over your AI infrastructure
- GDPR/compliance-friendly

**⚡ Performance Optimized**
- Automatic GPU detection and acceleration
- Efficient resource management
- Optimized Docker networking
- Fast model loading and inference

**🛠️ Production Ready**
- Used in real-world AI automation
- Comprehensive error handling
- Health checks on all services
- Persistent data storage
- Easy backup and restore

**🚀 Easy to Use**
- One-command installation
- Cross-platform (Windows, Linux, macOS)
- Interactive management scripts
- Pre-built workflow templates
- Comprehensive documentation

**🔄 Fully Integrated**
- Services communicate seamlessly
- Pre-configured networking
- Ready-to-use workflow template
- No manual configuration needed

**💰 Cost Effective**
- 100% free and open source
- No subscription fees
- No per-request API costs
- Run unlimited workflows

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

### 🐳 Don't Have Docker?

**[→ Docker Installation Guide](DOCKER-INSTALLATION.md)** - Step-by-step instructions for Windows, Linux, and macOS.

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

### 🖼️ AI Image Generator Workflow (Included!)

The stack includes a **complete, production-ready workflow** that demonstrates the power of combining these services. Here's how it works:

#### Workflow Architecture

```
User Input
    ↓
┌─────────────────────────────────────────┐
│  Chat Trigger (n8n)                     │
│  - Receives user messages               │
│  - Provides interactive chat interface  │
└─────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────┐
│  Smart Detection                        │
│  - Checks if message contains "image"   │
│  - Routes to appropriate path           │
└─────────────────────────────────────────┘
    ↓                          ↓
[IMAGE PATH]              [CHAT PATH]
    ↓                          ↓
┌──────────────────────┐  ┌─────────────────┐
│  Prompt Engineering  │  │  Regular Chat   │
│  (Ollama/qwen2.5)    │  │  (Ollama/phi4)  │
│  - Analyzes request  │  │  - Conversational│
│  - Detects style     │  │  - Helpful       │
│  - Enhances prompt   │  │  - Contextual   │
│  - Adds quality tags │  └─────────────────┘
└──────────────────────┘           ↓
    ↓                        [Return Response]
┌──────────────────────┐
│  Parse JSON Response │
│  - Extracts positive │
│  - Extracts negative │
└──────────────────────┘
    ↓
┌──────────────────────┐
│  Build ComfyUI API   │
│  - Quality presets   │
│  - Dimension detect  │
│  - Style optimize    │
│  - Generate workflow │
└──────────────────────┘
    ↓
┌──────────────────────┐
│  POST to ComfyUI     │
│  - Send prompt       │
│  - Get prompt_id     │
└──────────────────────┘
    ↓
┌──────────────────────┐
│  Dynamic Wait        │
│  - Calculate time    │
│  - Based on quality  │
│  - Based on size     │
└──────────────────────┘
    ↓
┌──────────────────────┐
│  Check Status        │
│  - Poll history      │
│  - Verify complete   │
└──────────────────────┘
    ↓
┌──────────────────────┐
│  Download Image      │
│  - Get image URL     │
│  - Fetch binary data │
└──────────────────────┘
    ↓
┌──────────────────────┐
│  Format Response     │
│  - Create message    │
│  - Embed image       │
│  - Add metadata      │
└──────────────────────┘
    ↓
[Return to User]
```

#### Intelligent Features

**1. Smart Style Detection**
```javascript
Input: "generate image of Rick and Morty"
Detection: Cartoon character names → Auto-use cartoon style
Output: Vibrant cartoon with bold outlines and cel shading

Input: "generate portrait of a woman"
Detection: Real person + portrait → Photorealistic style
Output: Professional photography with natural lighting

Input: "generate image of a dragon"
Detection: Fantasy creature + no style specified → Artistic painting
Output: Oil painting with dramatic lighting
```

**2. Quality Control**
```javascript
User says: "quick image of a sunset"
→ Uses draft preset (20 steps, faster)

User says: "high quality landscape image"
→ Uses high preset (50 steps, detailed)

User says: "ultra detailed portrait"
→ Uses ultra preset (70 steps, maximum quality)
```

**3. Automatic Dimensions**
```javascript
"portrait image" → 512x768 (portrait orientation)
"landscape image" → 768x512 (landscape orientation)
"1024 image" → 1024x1024 (high resolution)
"4k image" → 2048x2048 (ultra high resolution)
"phone wallpaper" → 480x853 (mobile)
```

**4. Dual-Mode Operation**
```javascript
"generate image of a sunset"
→ Routes to IMAGE PATH → Uses ComfyUI

"what's the weather like?"
→ Routes to CHAT PATH → Uses Ollama chat

"hello, how are you?"
→ Routes to CHAT PATH → Normal conversation
```

#### Example Interactions

**Example 1: Simple Image Request**
```
User: "generate image of a sunset over mountains"

Workflow Process:
1. Detects "image" keyword ✓
2. Ollama enhances: "RAW photo, professional landscape photography 
   of majestic mountains at sunset, golden hour lighting, warm 
   orange and purple sky, natural colors, panoramic view..."
3. Builds ComfyUI workflow (high quality, landscape)
4. Generates image (35 steps, ~18 seconds)
5. Returns embedded image with settings

User receives: Beautiful sunset image + metadata
```

**Example 2: Cartoon Style**
```
User: "generate cartoon image of a friendly dragon"

Workflow Process:
1. Detects "image" + "cartoon" ✓
2. Ollama creates cartoon prompt: "digital illustration of 
   friendly dragon, cartoon style, vibrant colors, bold 
   outlines, cel shaded..."
3. Adjusts sampler to "euler" (better for cartoons)
4. CFG set to 11.0 (stronger style adherence)
5. Generates vibrant cartoon image

User receives: Colorful cartoon dragon
```

**Example 3: Quality + Size Control**
```
User: "generate ultra quality 1024 portrait of a woman"

Workflow Process:
1. Detects: "ultra" → 70 steps
2. Detects: "1024" → 1024x1024 resolution
3. Detects: "portrait" → portrait composition keywords
4. Ollama adds: "detailed facial features, realistic skin 
   texture, professional portrait photography..."
5. Generates high-quality portrait (~38 seconds)

User receives: Ultra-detailed portrait image
```

**Example 4: Regular Chat**
```
User: "tell me about the weather today"

Workflow Process:
1. No "image" keyword detected
2. Routes to chat path
3. Ollama (phi4) responds conversationally
4. No ComfyUI involved

User receives: Helpful text response
```

#### Workflow Benefits

✅ **Intelligent** - Automatically detects style, quality, and dimensions
✅ **Fast** - Dynamic wait times based on complexity
✅ **Flexible** - Works for images AND regular chat
✅ **Quality** - Professional prompt engineering built-in
✅ **User-Friendly** - Simple natural language interface
✅ **Extensible** - Easy to customize and expand

#### 📚 Complete Workflow Documentation

Want to understand exactly how it works or customize it?

**[→ Workflow Deep Dive](WORKFLOW-DEEP-DIVE.md)** - 15,000+ word comprehensive guide covering:
- 🔍 **Node-by-Node Breakdown** - Every node explained in detail
- 📊 **Data Flow Visualization** - See exactly what data moves where
- 🎨 **Customization Guide** - Add quality presets, dimensions, models
- 🔧 **Advanced Modifications** - Image-to-image, batch generation, upscaling
- 🐛 **Troubleshooting** - Solutions to common issues
- 💡 **Example Code** - Copy-paste ready modifications

**[→ N8N Workflow Guide](N8N-WORKFLOW-GUIDE.md)** - Setup and usage guide:
- 📥 How to import the workflow
- ⚙️ Configuration steps
- 🧪 Testing examples
- 🔗 Connecting to services

**Quick Links:**
- [How to modify quality presets →](WORKFLOW-DEEP-DIVE.md#1-add-new-quality-presets)
- [How to add custom dimensions →](WORKFLOW-DEEP-DIVE.md#2-add-custom-dimensions)
- [How to switch AI models →](WORKFLOW-DEEP-DIVE.md#5-switch-llm-models)
- [How to change detection keywords →](WORKFLOW-DEEP-DIVE.md#4-change-detection-keywords)

### 🚀 More Workflow Ideas

Once you understand the included workflow, you can build:

**Content Creation Pipeline**
```
Schedule Trigger → Ollama (generate topic) → Ollama (write article) 
→ ComfyUI (create featured image) → Post to WordPress
```

**Smart Social Media Manager**
```
RSS Feed → Ollama (summarize article) → ComfyUI (generate thumbnail)
→ Ollama (write caption) → Post to Twitter/LinkedIn
```

**Document Intelligence**
```
Watch Folder → Extract text → Generate embeddings → Store in Qdrant
→ Ollama (answer questions) using RAG
```

**Image Processing Factory**
```
Upload Image → ComfyUI (upscale) → ComfyUI (enhance) 
→ ComfyUI (style transfer) → Save to cloud
```

**Custom AI Assistant**
```
Webhook → Check Qdrant for context → Ollama (generate response)
→ Update Qdrant with new context → Return answer
```

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
