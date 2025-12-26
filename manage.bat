@echo off
REM Quick management script for AI Development Stack
REM Place this in your ai-dev-stack directory

:menu
cls
echo ========================================
echo   AI Development Stack Manager
echo ========================================
echo.
echo 1. Start all services
echo 2. Stop all services
echo 3. Restart all services
echo 4. View status
echo 5. View logs (all)
echo 6. View ComfyUI logs
echo 7. View Ollama logs
echo 8. View n8n logs
echo 9. Download new Ollama model
echo 10. List Ollama models
echo 11. Open ComfyUI in browser
echo 12. Open n8n in browser
echo 13. Open Qdrant in browser
echo 14. Update all images
echo 0. Exit
echo.
set /p choice="Enter your choice: "

if "%choice%"=="1" goto start
if "%choice%"=="2" goto stop
if "%choice%"=="3" goto restart
if "%choice%"=="4" goto status
if "%choice%"=="5" goto logs
if "%choice%"=="6" goto logs_comfyui
if "%choice%"=="7" goto logs_ollama
if "%choice%"=="8" goto logs_n8n
if "%choice%"=="9" goto pull_model
if "%choice%"=="10" goto list_models
if "%choice%"=="11" goto open_comfyui
if "%choice%"=="12" goto open_n8n
if "%choice%"=="13" goto open_qdrant
if "%choice%"=="14" goto update
if "%choice%"=="0" exit
goto menu

:start
echo.
echo Starting all services...
docker compose up -d
echo.
pause
goto menu

:stop
echo.
echo Stopping all services...
docker compose down
echo.
pause
goto menu

:restart
echo.
echo Restarting all services...
docker compose restart
echo.
pause
goto menu

:status
echo.
docker compose ps
echo.
pause
goto menu

:logs
echo.
echo Press Ctrl+C to stop viewing logs
echo.
docker compose logs -f
pause
goto menu

:logs_comfyui
echo.
echo Press Ctrl+C to stop viewing logs
echo.
docker compose logs -f comfyui
pause
goto menu

:logs_ollama
echo.
echo Press Ctrl+C to stop viewing logs
echo.
docker compose logs -f ollama
pause
goto menu

:logs_n8n
echo.
echo Press Ctrl+C to stop viewing logs
echo.
docker compose logs -f n8n
pause
goto menu

:pull_model
echo.
echo Popular models:
echo   phi4:latest (14B, ~8GB)
echo   llama3.2 (3B, ~2GB)
echo   qwen2.5-coder:latest (7B, ~4.7GB)
echo   mistral:latest (7B, ~4GB)
echo.
set /p model="Enter model name: "
docker exec -it ollama ollama pull %model%
echo.
pause
goto menu

:list_models
echo.
docker exec -it ollama ollama list
echo.
pause
goto menu

:open_comfyui
start http://localhost:8188
goto menu

:open_n8n
start http://localhost:5678
goto menu

:open_qdrant
start http://localhost:6333/dashboard
goto menu

:update
echo.
echo Pulling latest images...
docker compose pull
echo.
echo Restarting services...
docker compose up -d
echo.
pause
goto menu
