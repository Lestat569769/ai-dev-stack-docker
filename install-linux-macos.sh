#!/bin/bash

#==============================================================================
# AI Development Stack Installer for Linux/macOS
# ComfyUI + Ollama (phi4) + n8n + Qdrant + PostgreSQL
#==============================================================================

set -e  # Exit on error

# Color output functions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

print_success() { echo -e "${GREEN}$1${NC}"; }
print_info() { echo -e "${CYAN}$1${NC}"; }
print_warn() { echo -e "${YELLOW}$1${NC}"; }
print_error() { echo -e "${RED}$1${NC}"; }
print_header() { echo -e "${MAGENTA}$1${NC}"; }

clear
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                            ║
║     AI Development Stack Installer (Linux/macOS)         ║
║     ComfyUI + Ollama + n8n + Qdrant + PostgreSQL         ║
║                                                            ║
╚═══════════════════════════════════════════════════════════╝
EOF

print_info "\nThis script will install:"
print_info "  • ComfyUI (Stable Diffusion GUI) - Port 8188"
print_info "  • Ollama (Local LLM with phi4) - Port 11434"
print_info "  • n8n (Workflow automation) - Port 5678"
print_info "  • Qdrant (Vector database) - Port 6333"
print_info "  • PostgreSQL (Database) - Internal"
print_info "\nEstimated time: 20-30 minutes (first run)"
print_info "Required disk space: ~20GB"
print_info "Required RAM: 16GB+ recommended\n"

read -p "Continue with installation? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warn "Installation cancelled."
    exit 0
fi

#==============================================================================
# STEP 1: Detect OS and Check Prerequisites
#==============================================================================
print_info "\n[1/9] Detecting operating system and prerequisites..."

OS_TYPE=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_TYPE="linux"
    print_success "✓ Operating System: Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macos"
    print_success "✓ Operating System: macOS"
else
    print_error "ERROR: Unsupported operating system: $OSTYPE"
    exit 1
fi

# Check if running as root (not recommended)
if [ "$EUID" -eq 0 ]; then 
    print_warn "⚠ Running as root is not recommended"
    print_warn "  Consider running as a regular user"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Check available RAM
if [[ "$OS_TYPE" == "linux" ]]; then
    TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
elif [[ "$OS_TYPE" == "macos" ]]; then
    TOTAL_RAM=$(sysctl -n hw.memsize | awk '{print int($1/1024/1024/1024)}')
fi

print_info "  Detected RAM: ${TOTAL_RAM}GB"
if [ "$TOTAL_RAM" -lt 16 ]; then
    print_warn "  WARNING: 16GB+ RAM recommended. You have ${TOTAL_RAM}GB"
    print_warn "  AI models may run slowly with less RAM."
    read -p "  Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi
print_success "✓ RAM: ${TOTAL_RAM}GB"

# Check disk space
if [[ "$OS_TYPE" == "linux" ]]; then
    FREE_SPACE=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
elif [[ "$OS_TYPE" == "macos" ]]; then
    FREE_SPACE=$(df -g . | awk 'NR==2 {print $4}')
fi

print_info "  Free disk space: ${FREE_SPACE}GB"
if [ "$FREE_SPACE" -lt 30 ]; then
    print_error "ERROR: Need at least 30GB free space. You have ${FREE_SPACE}GB"
    exit 1
fi
print_success "✓ Disk space: ${FREE_SPACE}GB available"

# Check for NVIDIA GPU (Linux only)
USE_GPU=false
if [[ "$OS_TYPE" == "linux" ]]; then
    print_info "\nChecking for NVIDIA GPU..."
    if command -v nvidia-smi &> /dev/null; then
        GPU_INFO=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n1)
        print_success "✓ NVIDIA GPU detected: $GPU_INFO"
        
        # Check for nvidia-docker
        if docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi &> /dev/null; then
            print_success "✓ NVIDIA Docker runtime available"
            USE_GPU=true
        else
            print_warn "⚠ NVIDIA GPU found but Docker GPU support not available"
            print_warn "  Install nvidia-docker2 for GPU acceleration"
            USE_GPU=false
        fi
    else
        print_warn "⚠ No NVIDIA GPU detected - will run in CPU mode"
        USE_GPU=false
    fi
elif [[ "$OS_TYPE" == "macos" ]]; then
    print_info "⚠ macOS detected - GPU acceleration not supported in Docker"
    print_info "  Services will run in CPU mode"
    USE_GPU=false
fi

#==============================================================================
# STEP 2: Check Docker
#==============================================================================
print_info "\n[2/9] Checking Docker..."

if ! command -v docker &> /dev/null; then
    print_error "ERROR: Docker is not installed"
    print_info "\nSee our Docker installation guide:"
    print_info "https://github.com/Lestat569769/ai-dev-stack-docker/blob/main/DOCKER-INSTALLATION.md"
    print_info "\nQuick install:"
    if [[ "$OS_TYPE" == "linux" ]]; then
        print_info "  curl -fsSL https://get.docker.com | sh"
        print_info "  sudo usermod -aG docker $USER"
        print_info "  Then log out and log back in"
    elif [[ "$OS_TYPE" == "macos" ]]; then
        print_info "  Download Docker Desktop from:"
        print_info "  https://www.docker.com/products/docker-desktop"
    fi
    exit 1
fi

DOCKER_VERSION=$(docker --version)
print_success "✓ Docker installed: $DOCKER_VERSION"

# Check if Docker daemon is running
if ! docker ps &> /dev/null; then
    print_error "ERROR: Docker daemon is not running"
    print_info "Start Docker and run this script again"
    
    if [[ "$OS_TYPE" == "macos" ]]; then
        print_info "Open Docker Desktop application"
    elif [[ "$OS_TYPE" == "linux" ]]; then
        print_info "sudo systemctl start docker"
    fi
    exit 1
fi
print_success "✓ Docker daemon is running"

# Check Docker Compose
if docker compose version &> /dev/null; then
    COMPOSE_VERSION=$(docker compose version)
    print_success "✓ Docker Compose available: $COMPOSE_VERSION"
else
    print_error "ERROR: Docker Compose is not available"
    print_info "Update Docker to the latest version"
    exit 1
fi

# Check if user can run Docker without sudo (Linux)
if [[ "$OS_TYPE" == "linux" ]] && [ "$EUID" -ne 0 ]; then
    if ! docker ps &> /dev/null; then
        print_warn "⚠ User $USER cannot run Docker without sudo"
        print_info "Add yourself to docker group:"
        print_info "  sudo usermod -aG docker $USER"
        print_info "  Then log out and log back in"
        exit 1
    fi
fi

#==============================================================================
# STEP 3: Setup Installation Directory
#==============================================================================
print_info "\n[3/9] Setting up installation directory..."

INSTALL_DIR="$HOME/ai-dev-stack"

if [ -d "$INSTALL_DIR" ]; then
    print_warn "Directory already exists: $INSTALL_DIR"
    read -p "Remove existing installation? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Stopping any running containers..."
        cd "$INSTALL_DIR"
        docker compose down 2>/dev/null || true
        
        print_info "Removing old installation..."
        cd "$HOME"
        rm -rf "$INSTALL_DIR"
        print_success "✓ Old installation removed"
    else
        print_info "Using existing directory"
        cd "$INSTALL_DIR"
    fi
else
    print_info "Creating directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    print_success "✓ Installation directory created"
fi

#==============================================================================
# STEP 4: Create Docker Compose File
#==============================================================================
print_info "\n[4/9] Creating Docker Compose configuration..."

# Start building compose file
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  # ComfyUI - Stable Diffusion GUI
  comfyui:
    image: yanwk/comfyui-boot:latest
    container_name: comfyui
    ports:
      - "8188:8188"
    environment:
      - CLI_ARGS=--listen 0.0.0.0 --port 8188 --enable-cors-header "*"
    volumes:
      - comfyui-data:/home/runner
      - ./comfyui/models:/home/runner/models
      - ./comfyui/input:/home/runner/input
      - ./comfyui/output:/home/runner/output
      - ./comfyui/custom_nodes:/home/runner/custom_nodes
EOF

# Add GPU support if available
if [ "$USE_GPU" = true ]; then
    cat >> docker-compose.yml << 'EOF'
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
EOF
fi

# Continue with rest of compose file
cat >> docker-compose.yml << 'EOF'
    restart: unless-stopped
    networks:
      - ai-network

  # Ollama - Local LLM server
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    ports:
      - "11434:11434"
    volumes:
      - ollama-data:/root/.ollama
    environment:
      - OLLAMA_HOST=0.0.0.0
EOF

# Add GPU support for Ollama if available
if [ "$USE_GPU" = true ]; then
    cat >> docker-compose.yml << 'EOF'
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
EOF
fi

# Finish compose file
cat >> docker-compose.yml << 'EOF'
    restart: unless-stopped
    networks:
      - ai-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:11434/api/tags"]
      interval: 30s
      timeout: 10s
      retries: 3

  # n8n - Workflow automation
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=localhost
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - WEBHOOK_URL=http://localhost:5678/
      - GENERIC_TIMEZONE=America/New_York
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
      - DB_POSTGRESDB_USER=${POSTGRES_USER}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - n8n-data:/home/node/.n8n
      - ./n8n/backup:/backup
    depends_on:
      - postgres
      - ollama
    restart: unless-stopped
    networks:
      - ai-network

  # PostgreSQL - Database for n8n
  postgres:
    image: postgres:16-alpine
    container_name: postgres
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: unless-stopped
    networks:
      - ai-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Qdrant - Vector database
  qdrant:
    image: qdrant/qdrant:latest
    container_name: qdrant
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - qdrant-data:/qdrant/storage
    restart: unless-stopped
    networks:
      - ai-network

volumes:
  comfyui-data:
  ollama-data:
  n8n-data:
  postgres-data:
  qdrant-data:

networks:
  ai-network:
    driver: bridge
EOF

print_success "✓ Docker Compose configuration created"

#==============================================================================
# STEP 5: Create Environment File
#==============================================================================
print_info "\n[5/9] Creating environment configuration..."

if [ ! -f ".env" ]; then
    # Generate random encryption key (32 chars)
    ENCRYPTION_KEY=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    POSTGRES_PASSWORD="n8n_pass_$(shuf -i 10000-99999 -n 1 2>/dev/null || echo $RANDOM)"
    
    cat > .env << EOF
# n8n Configuration
N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY

# PostgreSQL Configuration
POSTGRES_USER=n8n
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_DB=n8n

# Ollama Configuration
OLLAMA_MODEL=phi4:latest
EOF
    
    print_success "✓ Environment file created with secure random credentials"
else
    print_info "Using existing .env file"
fi

#==============================================================================
# STEP 6: Create Directory Structure and Workflow Template
#==============================================================================
print_info "\n[6/9] Creating directory structure and workflow template..."

mkdir -p comfyui/{models,input,output,custom_nodes}
mkdir -p n8n/{backup,workflows}
mkdir -p webui

# Create n8n workflow template
cat > n8n/workflows/AI-Image-Generator-Template.json << 'WORKFLOW_EOF'
{
  "name": "🎨 AI Image Generator with ComfyUI + Ollama",
  "nodes": [
    {
      "parameters": {
        "conditions": {
          "options": {"caseSensitive": false, "leftValue": "", "typeValidation": "strict"},
          "conditions": [{
            "id": "c1",
            "leftValue": "={{ $json.chatInput.toLowerCase() }}",
            "rightValue": "image",
            "operator": {"type": "string", "operation": "contains", "singleValue": true}
          }],
          "combinator": "and"
        },
        "options": {}
      },
      "id": "contains-image-check",
      "name": "Contains 'image'?",
      "type": "n8n-nodes-base.if",
      "typeVersion": 2.2,
      "position": [800, 400]
    },
    {
      "parameters": {
        "public": true,
        "availableInChat": true,
        "agentName": "AI Image Generator",
        "agentDescription": "Generate images with ComfyUI and chat with Ollama",
        "options": {}
      },
      "type": "@n8n/n8n-nodes-langchain.chatTrigger",
      "typeVersion": 1.4,
      "position": [600, 400],
      "id": "chat-trigger",
      "name": "Chat Trigger"
    }
  ],
  "pinData": {},
  "connections": {
    "Chat Trigger": {
      "main": [[{"node": "Contains 'image'?", "type": "main", "index": 0}]]
    }
  },
  "active": false,
  "settings": {"executionOrder": "v1"},
  "tags": ["starter", "comfyui", "ollama"]
}
WORKFLOW_EOF

print_success "✓ Directory structure and workflow template created"

#==============================================================================
# STEP 7: Pull Docker Images
#==============================================================================
print_info "\n[7/9] Pulling Docker images..."
print_warn "This will download ~10-15GB of data (one-time)"
print_warn "Estimated time: 10-20 minutes depending on internet speed"
echo

docker compose pull
print_success "\n✓ All images downloaded successfully"

#==============================================================================
# STEP 8: Start Services
#==============================================================================
print_info "\n[8/9] Starting all services..."
print_info "This may take 2-3 minutes on first launch..."

docker compose up -d

if [ $? -eq 0 ]; then
    print_success "✓ All containers started successfully"
else
    print_error "ERROR: Failed to start services"
    print_info "\nTroubleshooting:"
    print_info "1. Check Docker is running"
    print_info "2. View logs: docker compose logs"
    print_info "3. Check ports: netstat -tuln | grep -E ':(8188|11434|5678|6333)'"
    exit 1
fi

# Wait for services
print_info "\nWaiting for services to initialize..."
sleep 10

# Check service health
print_info "\nChecking service health..."

check_service() {
    local name=$1
    local url=$2
    local max_attempts=12
    local attempt=0
    
    echo -n "  Checking $name... "
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s -f "$url" > /dev/null 2>&1; then
            print_success "✓ Ready"
            return 0
        fi
        attempt=$((attempt + 1))
        sleep 5
    done
    
    print_warn "⚠ Starting (may take a few more minutes)"
    return 1
}

check_service "ComfyUI" "http://localhost:8188"
check_service "Ollama" "http://localhost:11434/api/tags"
check_service "n8n" "http://localhost:5678"
check_service "Qdrant" "http://localhost:6333"

#==============================================================================
# STEP 9: Download phi4 Model
#==============================================================================
print_info "\n[9/9] Downloading phi4 model for Ollama..."
print_info "phi4 is a 14B parameter model (~8GB download)"
print_warn "This will take 10-15 minutes depending on internet speed"
echo

read -p "Download phi4:latest now? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Downloading phi4:latest model..."
    print_info "You can monitor progress below:"
    echo
    
    docker exec -it ollama ollama pull phi4:latest && \
        print_success "\n✓ phi4 model downloaded successfully" || \
        print_warn "Model download failed or was interrupted. Download later with:\n  docker exec -it ollama ollama pull phi4:latest"
else
    print_info "Skipped. Download later with:"
    print_info "  docker exec -it ollama ollama pull phi4:latest"
fi

#==============================================================================
# Installation Complete!
#==============================================================================
echo
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                            ║
║            ✅ INSTALLATION COMPLETED! ✅                  ║
║                                                            ║
╚═══════════════════════════════════════════════════════════╝
EOF

print_success "\nYour AI Development Stack is running!\n"

print_info "🌐 Access Points:"
echo -e "  ComfyUI:        ${CYAN}http://localhost:8188${NC}"
echo -e "  n8n Workflows:  ${CYAN}http://localhost:5678${NC}"
echo -e "  Ollama API:     ${CYAN}http://localhost:11434${NC}"
echo -e "  Qdrant:         ${CYAN}http://localhost:6333/dashboard${NC}"

print_info "\n🎨 ComfyUI (Stable Diffusion):"
print_info "  • Web interface for image generation"
print_info "  • Download models to: $INSTALL_DIR/comfyui/models"
print_info "  • Popular model sites:"
print_info "    - https://civitai.com"
print_info "    - https://huggingface.co"

print_info "\n🤖 Ollama (Local LLM):"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "  • phi4:latest is installed and ready"
else
    print_info "  • Install phi4: docker exec -it ollama ollama pull phi4:latest"
fi
print_info "  • List models: docker exec -it ollama ollama list"
print_info "  • More models: https://ollama.com/library"
print_info "  • Popular models:"
print_info "    - phi4:latest (14B, ~8GB) - Microsoft's latest"
print_info "    - llama3.2 (3B, ~2GB) - Fast, general purpose"
print_info "    - qwen2.5-coder (7B, ~4.7GB) - Code generation"

print_info "\n🔄 n8n (Automation):"
print_info "  • Connect ComfyUI + Ollama in workflows"
print_info "  • Create your account at http://localhost:5678"
print_info "  • Import the starter template from:"
print_info "    $INSTALL_DIR/n8n/workflows/AI-Image-Generator-Template.json"
print_info "  • More templates at n8n.io"

print_info "\n⚙️  Management Commands:"
echo -e "  Start:    ${YELLOW}docker compose up -d${NC}"
echo -e "  Stop:     ${YELLOW}docker compose down${NC}"
echo -e "  Restart:  ${YELLOW}docker compose restart${NC}"
echo -e "  Logs:     ${YELLOW}docker compose logs -f [service-name]${NC}"
echo -e "  Status:   ${YELLOW}docker compose ps${NC}"

print_info "\n📁 Installation Location:"
echo "  $INSTALL_DIR"

print_info "\n🔧 Useful Tips:"
print_info "  • All data persists in Docker volumes"
print_info "  • GPU support: $([ "$USE_GPU" = true ] && echo 'Enabled ✓' || echo 'Disabled (CPU mode)')"
print_info "  • ComfyUI custom nodes: $INSTALL_DIR/comfyui/custom_nodes"
print_info "  • Backup n8n: docker compose exec n8n n8n export:workflow --all"
print_info "  • Reset everything: docker compose down -v"

print_info "\n📖 Documentation:"
print_info "  ComfyUI: https://github.com/comfyanonymous/ComfyUI"
print_info "  Ollama: https://ollama.com/library"
print_info "  n8n: https://docs.n8n.io/"
print_info "  Qdrant: https://qdrant.tech/documentation/"

print_info "\n🚀 Quick Start Guide:"
print_info "  1. Open ComfyUI at http://localhost:8188"
print_info "  2. Download a Stable Diffusion model from civitai.com"
print_info "  3. Open n8n at http://localhost:5678 and create account"
print_info "  4. Connect Ollama to n8n for AI automations"

echo
read -p "Open ComfyUI in browser now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:8188" 2>/dev/null
    elif command -v open &> /dev/null; then
        open "http://localhost:8188"
    fi
fi

read -p "Open n8n in browser now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:5678" 2>/dev/null
    elif command -v open &> /dev/null; then
        open "http://localhost:5678"
    fi
fi

print_header "\n🎉 Happy Creating! 🚀"
echo
