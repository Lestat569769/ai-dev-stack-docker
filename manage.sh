#!/bin/bash

# Quick management script for AI Development Stack
# Place this in your ai-dev-stack directory

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_menu() {
    clear
    echo -e "${CYAN}========================================"
    echo "   AI Development Stack Manager"
    echo -e "========================================${NC}"
    echo
    echo "1.  Start all services"
    echo "2.  Stop all services"
    echo "3.  Restart all services"
    echo "4.  View status"
    echo "5.  View logs (all)"
    echo "6.  View ComfyUI logs"
    echo "7.  View Ollama logs"
    echo "8.  View n8n logs"
    echo "9.  Download new Ollama model"
    echo "10. List Ollama models"
    echo "11. Test Ollama model"
    echo "12. Open ComfyUI in browser"
    echo "13. Open n8n in browser"
    echo "14. Open Qdrant in browser"
    echo "15. Update all images"
    echo "16. Backup workflows"
    echo "0.  Exit"
    echo
    read -p "Enter your choice: " choice
}

start_services() {
    echo
    echo -e "${GREEN}Starting all services...${NC}"
    docker compose up -d
    echo
    read -p "Press Enter to continue..."
}

stop_services() {
    echo
    echo -e "${YELLOW}Stopping all services...${NC}"
    docker compose down
    echo
    read -p "Press Enter to continue..."
}

restart_services() {
    echo
    echo -e "${YELLOW}Restarting all services...${NC}"
    docker compose restart
    echo
    read -p "Press Enter to continue..."
}

show_status() {
    echo
    docker compose ps
    echo
    read -p "Press Enter to continue..."
}

show_logs() {
    echo
    echo -e "${CYAN}Press Ctrl+C to stop viewing logs${NC}"
    echo
    docker compose logs -f
}

show_comfyui_logs() {
    echo
    echo -e "${CYAN}Press Ctrl+C to stop viewing logs${NC}"
    echo
    docker compose logs -f comfyui
}

show_ollama_logs() {
    echo
    echo -e "${CYAN}Press Ctrl+C to stop viewing logs${NC}"
    echo
    docker compose logs -f ollama
}

show_n8n_logs() {
    echo
    echo -e "${CYAN}Press Ctrl+C to stop viewing logs${NC}"
    echo
    docker compose logs -f n8n
}

pull_model() {
    echo
    echo "Popular models:"
    echo "  phi4:latest (14B, ~8GB)"
    echo "  llama3.2 (3B, ~2GB)"
    echo "  qwen2.5-coder:latest (7B, ~4.7GB)"
    echo "  mistral:latest (7B, ~4GB)"
    echo "  codellama:latest (7B, ~4GB)"
    echo
    read -p "Enter model name: " model
    docker exec -it ollama ollama pull "$model"
    echo
    read -p "Press Enter to continue..."
}

list_models() {
    echo
    docker exec -it ollama ollama list
    echo
    read -p "Press Enter to continue..."
}

test_model() {
    echo
    read -p "Enter model name to test: " model
    read -p "Enter prompt: " prompt
    echo
    docker exec -it ollama ollama run "$model" "$prompt"
    echo
    read -p "Press Enter to continue..."
}

open_comfyui() {
    if command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:8188" 2>/dev/null
    elif command -v open &> /dev/null; then
        open "http://localhost:8188"
    else
        echo "Please open http://localhost:8188 in your browser"
    fi
}

open_n8n() {
    if command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:5678" 2>/dev/null
    elif command -v open &> /dev/null; then
        open "http://localhost:5678"
    else
        echo "Please open http://localhost:5678 in your browser"
    fi
}

open_qdrant() {
    if command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:6333/dashboard" 2>/dev/null
    elif command -v open &> /dev/null; then
        open "http://localhost:6333/dashboard"
    else
        echo "Please open http://localhost:6333/dashboard in your browser"
    fi
}

update_images() {
    echo
    echo -e "${GREEN}Pulling latest images...${NC}"
    docker compose pull
    echo
    echo -e "${GREEN}Restarting services...${NC}"
    docker compose up -d
    echo
    read -p "Press Enter to continue..."
}

backup_workflows() {
    echo
    backup_file="n8n-backup-$(date +%Y%m%d-%H%M%S).json"
    docker compose exec n8n n8n export:workflow --all --output="/backup/$backup_file"
    echo
    echo -e "${GREEN}Workflows backed up to: n8n/backup/$backup_file${NC}"
    echo
    read -p "Press Enter to continue..."
}

# Main loop
while true; do
    show_menu
    case $choice in
        1) start_services ;;
        2) stop_services ;;
        3) restart_services ;;
        4) show_status ;;
        5) show_logs ;;
        6) show_comfyui_logs ;;
        7) show_ollama_logs ;;
        8) show_n8n_logs ;;
        9) pull_model ;;
        10) list_models ;;
        11) test_model ;;
        12) open_comfyui ;;
        13) open_n8n ;;
        14) open_qdrant ;;
        15) update_images ;;
        16) backup_workflows ;;
        0) echo -e "\n${GREEN}Goodbye!${NC}\n"; exit 0 ;;
        *) echo -e "\n${YELLOW}Invalid choice${NC}"; sleep 2 ;;
    esac
done
