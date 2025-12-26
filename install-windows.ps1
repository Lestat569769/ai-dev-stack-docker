#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Install AI Development Stack (ComfyUI + Ollama + n8n) on Windows
.DESCRIPTION
    Automated installation with Docker
    Includes: ComfyUI, Ollama (phi4), n8n, Qdrant, PostgreSQL
.NOTES
    Author: AI Development Setup
    Version: 2.0
    Requirements: Windows 10/11, Docker Desktop, 16GB+ RAM, NVIDIA GPU (optional)
#>

# Color output functions
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Info { Write-Host $args -ForegroundColor Cyan }
function Write-Warn { Write-Host $args -ForegroundColor Yellow }
function Write-Fail { Write-Host $args -ForegroundColor Red }

Clear-Host
Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                                                            ║
║     AI Development Stack Installer for Windows           ║
║     ComfyUI + Ollama + n8n + Qdrant + PostgreSQL         ║
║                                                            ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Info "`nThis script will install:"
Write-Info "  • ComfyUI (Stable Diffusion GUI) - Port 8188"
Write-Info "  • Ollama (Local LLM with phi4) - Port 11434"
Write-Info "  • n8n (Workflow automation) - Port 5678"
Write-Info "  • Qdrant (Vector database) - Port 6333"
Write-Info "  • PostgreSQL (Database) - Internal"
Write-Info "`nEstimated time: 20-30 minutes (first run)"
Write-Info "Required disk space: ~20GB"
Write-Info "Required RAM: 16GB+ recommended`n"

$Confirm = Read-Host "Continue with installation? (Y/N)"
if ($Confirm -notmatch '^[Yy]') {
    Write-Warn "Installation cancelled."
    exit
}

# ============================================================================
# STEP 1: Check Prerequisites
# ============================================================================
Write-Info "`n[1/9] Checking prerequisites..."

# Check Administrator
$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $IsAdmin) {
    Write-Fail "ERROR: This script must be run as Administrator!"
    Write-Fail "Right-click PowerShell and select 'Run as Administrator'"
    exit 1
}
Write-Success "✓ Running as Administrator"

# Check Windows version
$WinVer = [System.Environment]::OSVersion.Version
if ($WinVer.Major -lt 10) {
    Write-Fail "ERROR: Windows 10/11 required"
    exit 1
}
Write-Success "✓ Windows version: $($WinVer.Major).$($WinVer.Minor)"

# Check RAM
$RAM = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB
Write-Info "  Detected RAM: $([math]::Round($RAM))GB"
if ($RAM -lt 16) {
    Write-Warn "  WARNING: 16GB+ RAM recommended. You have $([math]::Round($RAM))GB"
    $Continue = Read-Host "  Continue anyway? (Y/N)"
    if ($Continue -notmatch '^[Yy]') { exit }
}
Write-Success "✓ RAM: $([math]::Round($RAM))GB"

# Check disk space
$FreeSpace = (Get-PSDrive C | Select-Object -ExpandProperty Free) / 1GB
Write-Info "  Free disk space: $([math]::Round($FreeSpace))GB"
if ($FreeSpace -lt 30) {
    Write-Fail "ERROR: Need at least 30GB free space. You have $([math]::Round($FreeSpace))GB"
    exit 1
}
Write-Success "✓ Disk space: $([math]::Round($FreeSpace))GB available"

# Check for NVIDIA GPU
Write-Info "`nChecking for NVIDIA GPU..."
try {
    $GPU = Get-CimInstance Win32_VideoController | Where-Object { $_.Name -like "*NVIDIA*" }
    if ($GPU) {
        Write-Success "✓ NVIDIA GPU detected: $($GPU.Name)"
        $UseGPU = $true
    } else {
        Write-Warn "⚠ No NVIDIA GPU detected - will run in CPU mode"
        Write-Warn "  Performance will be slower without GPU"
        $UseGPU = $false
    }
} catch {
    Write-Warn "⚠ Could not detect GPU - assuming CPU mode"
    $UseGPU = $false
}

# ============================================================================
# STEP 2: Check Docker
# ============================================================================
Write-Info "`n[2/9] Checking Docker Desktop..."
try {
    $DockerVersion = docker --version 2>$null
    if ($DockerVersion) {
        Write-Success "✓ Docker installed: $DockerVersion"
        
        # Check if Docker is running
        try {
            docker ps > $null 2>&1
            Write-Success "✓ Docker is running"
        } catch {
            Write-Warn "Docker installed but not running"
            Write-Info "Attempting to start Docker Desktop..."
            
            $DockerPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
            if (Test-Path $DockerPath) {
                Start-Process $DockerPath
                Write-Info "Waiting for Docker to start (up to 3 minutes)..."
                
                $Timeout = 180
                $Elapsed = 0
                while ($Elapsed -lt $Timeout) {
                    Start-Sleep -Seconds 5
                    $Elapsed += 5
                    try {
                        docker ps > $null 2>&1
                        Write-Success "`n✓ Docker started successfully"
                        break
                    } catch {
                        Write-Host "." -NoNewline
                    }
                }
                
                if ($Elapsed -ge $Timeout) {
                    Write-Fail "`nERROR: Docker failed to start"
                    Write-Fail "Please start Docker Desktop manually and run this script again"
                    exit 1
                }
            } else {
                Write-Fail "Could not find Docker Desktop executable"
                exit 1
            }
        }
    } else {
        throw "Docker not found"
    }
} catch {
    Write-Fail "ERROR: Docker Desktop not installed or not in PATH"
    Write-Info "`nDocker Desktop is required. See installation guide:"
    Write-Info "https://github.com/Lestat569769/ai-dev-stack-docker/blob/main/DOCKER-INSTALLATION.md"
    Write-Info "`nOr download directly:"
    Write-Info "https://www.docker.com/products/docker-desktop"
    
    $OpenBrowser = Read-Host "`nOpen Docker installation guide? (Y/N)"
    if ($OpenBrowser -match '^[Yy]') {
        Start-Process "https://github.com/Lestat569769/ai-dev-stack-docker/blob/main/DOCKER-INSTALLATION.md"
    } else {
        $OpenDownload = Read-Host "Open Docker Desktop download page? (Y/N)"
        if ($OpenDownload -match '^[Yy]') {
            Start-Process "https://www.docker.com/products/docker-desktop"
        }
    }
    }
    exit 1
}

# Check Docker Compose
try {
    docker compose version > $null 2>&1
    Write-Success "✓ Docker Compose available"
} catch {
    Write-Fail "ERROR: Docker Compose not available"
    Write-Info "Update Docker Desktop to the latest version"
    exit 1
}

# ============================================================================
# STEP 3: Setup Installation Directory
# ============================================================================
Write-Info "`n[3/9] Setting up installation directory..."
$InstallDir = "$env:USERPROFILE\ai-dev-stack"

if (Test-Path $InstallDir) {
    Write-Warn "Directory already exists: $InstallDir"
    $Overwrite = Read-Host "Remove existing installation? (Y/N)"
    if ($Overwrite -match '^[Yy]') {
        Write-Info "Stopping any running containers..."
        Set-Location $InstallDir
        docker compose down 2>$null
        
        Write-Info "Removing old installation..."
        Set-Location $env:USERPROFILE
        Remove-Item -Path $InstallDir -Recurse -Force
        Write-Success "✓ Old installation removed"
    } else {
        Write-Info "Using existing directory"
        Set-Location $InstallDir
    }
} else {
    Write-Info "Creating directory: $InstallDir"
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    Set-Location $InstallDir
    Write-Success "✓ Installation directory created"
}

# ============================================================================
# STEP 4: Create Docker Compose File
# ============================================================================
Write-Info "`n[4/9] Creating Docker Compose configuration..."

# Determine if we should include GPU support
$ComposeContent = @'
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
'@

if ($UseGPU) {
    $ComposeContent += @'

    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
'@
}

$ComposeContent += @'

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
'@

if ($UseGPU) {
    $ComposeContent += @'

    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
'@
}

$ComposeContent += @'

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
'@

$ComposeContent | Out-File -FilePath "docker-compose.yml" -Encoding UTF8
Write-Success "✓ Docker Compose configuration created"

# ============================================================================
# STEP 5: Create Environment File
# ============================================================================
Write-Info "`n[5/9] Creating environment configuration..."

if (-not (Test-Path ".env")) {
    # Generate random encryption key
    $EncryptionKey = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
    $PostgresPassword = "n8n_pass_$(Get-Random -Minimum 10000 -Maximum 99999)"
    
    $EnvContent = @"
# n8n Configuration
N8N_ENCRYPTION_KEY=$EncryptionKey

# PostgreSQL Configuration
POSTGRES_USER=n8n
POSTGRES_PASSWORD=$PostgresPassword
POSTGRES_DB=n8n

# Ollama Configuration
OLLAMA_MODEL=phi4:latest
"@
    
    $EnvContent | Out-File -FilePath ".env" -Encoding UTF8
    Write-Success "✓ Environment file created with secure random credentials"
} else {
    Write-Info "Using existing .env file"
}

# ============================================================================
# STEP 6: Create Directory Structure and Workflow Template
# ============================================================================
Write-Info "`n[6/9] Creating directory structure and workflow template..."

$Directories = @(
    "comfyui/models",
    "comfyui/input",
    "comfyui/output",
    "comfyui/custom_nodes",
    "n8n/backup",
    "n8n/workflows",
    "webui"
)

foreach ($Dir in $Directories) {
    New-Item -ItemType Directory -Path $Dir -Force | Out-Null
}

# Create n8n workflow template
$WorkflowTemplate = @'
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
'@

$WorkflowTemplate | Out-File -FilePath "n8n/workflows/AI-Image-Generator-Template.json" -Encoding UTF8
Write-Success "✓ Directory structure and workflow template created"

# ============================================================================
# STEP 7: Pull Docker Images
# ============================================================================
Write-Info "`n[7/9] Pulling Docker images..."
Write-Warn "This will download ~10-15GB of data (one-time)"
Write-Warn "Estimated time: 10-20 minutes depending on internet speed"
Write-Info ""

try {
    docker compose pull
    Write-Success "`n✓ All images downloaded successfully"
} catch {
    Write-Fail "ERROR: Failed to pull Docker images"
    Write-Fail $_.Exception.Message
    exit 1
}

# ============================================================================
# STEP 8: Start Services
# ============================================================================
Write-Info "`n[8/9] Starting all services..."
Write-Info "This may take 2-3 minutes on first launch..."

try {
    docker compose up -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "✓ All containers started successfully"
    } else {
        throw "Docker compose up failed"
    }
} catch {
    Write-Fail "ERROR: Failed to start services"
    Write-Fail $_.Exception.Message
    Write-Info "`nTroubleshooting:"
    Write-Info "1. Check Docker Desktop is running"
    Write-Info "2. View logs: docker compose logs"
    Write-Info "3. Check ports not in use: netstat -ano | findstr ':8188 :11434 :5678'"
    exit 1
}

# Wait for services to be healthy
Write-Info "`nWaiting for services to initialize..."
Start-Sleep -Seconds 10

# Check service status
Write-Info "`nChecking service health..."
$Services = @(
    @{Name="ComfyUI"; Port=8188; URL="http://localhost:8188"},
    @{Name="Ollama"; Port=11434; URL="http://localhost:11434/api/tags"},
    @{Name="n8n"; Port=5678; URL="http://localhost:5678"},
    @{Name="Qdrant"; Port=6333; URL="http://localhost:6333"}
)

foreach ($Service in $Services) {
    Write-Host "  Checking $($Service.Name)... " -NoNewline
    $MaxAttempts = 12
    $Attempt = 0
    $Ready = $false
    
    while ($Attempt -lt $MaxAttempts -and -not $Ready) {
        try {
            $Response = Invoke-WebRequest -Uri $Service.URL -Method Get -TimeoutSec 2 -UseBasicParsing -ErrorAction SilentlyContinue
            if ($Response.StatusCode -eq 200) {
                Write-Success "✓ Ready"
                $Ready = $true
            }
        } catch {
            $Attempt++
            Start-Sleep -Seconds 5
        }
    }
    
    if (-not $Ready) {
        Write-Warn "⚠ Starting (may take a few more minutes)"
    }
}

# ============================================================================
# STEP 9: Download phi4 Model
# ============================================================================
Write-Info "`n[9/9] Downloading phi4 model for Ollama..."
Write-Info "phi4 is a 14B parameter model (~8GB download)"
Write-Warn "This will take 10-15 minutes depending on internet speed"
Write-Info ""

$DownloadModel = Read-Host "Download phi4:latest now? (Y/N)"

if ($DownloadModel -match '^[Yy]') {
    Write-Info "Downloading phi4:latest model..."
    Write-Info "You can monitor progress below:`n"
    
    try {
        docker exec -it ollama ollama pull phi4:latest
        Write-Success "`n✓ phi4 model downloaded successfully"
    } catch {
        Write-Warn "Model download failed or was interrupted"
        Write-Info "You can download it later with:"
        Write-Info "  docker exec -it ollama ollama pull phi4:latest"
    }
} else {
    Write-Info "Skipped. Download later with:"
    Write-Info "  docker exec -it ollama ollama pull phi4:latest"
}

# ============================================================================
# Installation Complete!
# ============================================================================
Write-Host "`n"
Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                                                            ║
║            ✅ INSTALLATION COMPLETED! ✅                  ║
║                                                            ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Success "`nYour AI Development Stack is running!`n"

Write-Info "🌐 Access Points:"
Write-Host "  ComfyUI:        " -NoNewline; Write-Host "http://localhost:8188" -ForegroundColor Cyan
Write-Host "  n8n Workflows:  " -NoNewline; Write-Host "http://localhost:5678" -ForegroundColor Cyan
Write-Host "  Ollama API:     " -NoNewline; Write-Host "http://localhost:11434" -ForegroundColor Cyan
Write-Host "  Qdrant:         " -NoNewline; Write-Host "http://localhost:6333/dashboard" -ForegroundColor Cyan

Write-Info "`n🎨 ComfyUI (Stable Diffusion):"
Write-Info "  • Web interface for image generation"
Write-Info "  • Download models to: $InstallDir\comfyui\models"
Write-Info "  • Popular model sites:"
Write-Info "    - https://civitai.com"
Write-Info "    - https://huggingface.co"

Write-Info "`n🤖 Ollama (Local LLM):"
if ($DownloadModel -match '^[Yy]') {
    Write-Info "  • phi4:latest is installed and ready"
} else {
    Write-Info "  • Install phi4: docker exec -it ollama ollama pull phi4:latest"
}
Write-Info "  • List models: docker exec -it ollama ollama list"
Write-Info "  • More models: https://ollama.com/library"
Write-Info "  • Popular models:"
Write-Info "    - phi4:latest (14B, ~8GB) - Microsoft's latest"
Write-Info "    - llama3.2 (3B, ~2GB) - Fast, general purpose"
Write-Info "    - qwen2.5-coder (7B, ~4.7GB) - Code generation"

Write-Info "`n🔄 n8n (Automation):"
Write-Info "  • Connect ComfyUI + Ollama in workflows"
Write-Info "  • Create your account at http://localhost:5678"
Write-Info "  • Import the starter template from:"
Write-Info "    $InstallDir\n8n\workflows\AI-Image-Generator-Template.json"
Write-Info "  • More templates at n8n.io"

Write-Info "`n⚙️  Management Commands:"
Write-Host "  Start:    " -NoNewline; Write-Host "docker compose up -d" -ForegroundColor Yellow
Write-Host "  Stop:     " -NoNewline; Write-Host "docker compose down" -ForegroundColor Yellow
Write-Host "  Restart:  " -NoNewline; Write-Host "docker compose restart" -ForegroundColor Yellow
Write-Host "  Logs:     " -NoNewline; Write-Host "docker compose logs -f [service-name]" -ForegroundColor Yellow
Write-Host "  Status:   " -NoNewline; Write-Host "docker compose ps" -ForegroundColor Yellow

Write-Info "`n📁 Installation Location:"
Write-Host "  $InstallDir"

Write-Info "`n🔧 Useful Tips:"
Write-Info "  • All data persists in Docker volumes"
Write-Info "  • GPU support: $(if ($UseGPU) {'Enabled ✓'} else {'Disabled (CPU mode)'})"
Write-Info "  • ComfyUI custom nodes: $InstallDir\comfyui\custom_nodes"
Write-Info "  • Backup n8n: docker compose exec n8n n8n export:workflow --all"
Write-Info "  • Reset everything: docker compose down -v"

Write-Info "`n📖 Documentation:"
Write-Info "  ComfyUI: https://github.com/comfyanonymous/ComfyUI"
Write-Info "  Ollama: https://ollama.com/library"
Write-Info "  n8n: https://docs.n8n.io/"
Write-Info "  Qdrant: https://qdrant.tech/documentation/"

Write-Info "`n🚀 Quick Start Guide:"
Write-Info "  1. Open ComfyUI at http://localhost:8188"
Write-Info "  2. Download a Stable Diffusion model from civitai.com"
Write-Info "  3. Open n8n at http://localhost:5678 and create account"
Write-Info "  4. Connect Ollama to n8n for AI automations"

$OpenComfyUI = Read-Host "`nOpen ComfyUI in browser now? (Y/N)"
if ($OpenComfyUI -match '^[Yy]') {
    Start-Process "http://localhost:8188"
}

$Openn8n = Read-Host "Open n8n in browser now? (Y/N)"
if ($Openn8n -match '^[Yy]') {
    Start-Process "http://localhost:5678"
}

Write-Host "`n🎉 Happy Creating! 🚀" -ForegroundColor Magenta
Write-Host ""
