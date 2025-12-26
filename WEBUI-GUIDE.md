# 🌐 Adding Web UI Server to Your Stack

## What's New

A **Web UI Server** has been added to your AI Development Stack!

### Service Details:
- **Port:** 8890
- **Purpose:** Serve custom HTML/JavaScript interfaces
- **Technology:** Python HTTP server
- **Location:** `webui/` directory

## 🎯 What You Can Do

### Included Interface: AI Image Generator

A beautiful chat-style interface for generating images with ComfyUI.

**Access at:** http://localhost:8890/ai_image.html

**Features:**
- 🎨 Chat interface for image requests
- 📊 Real-time progress tracking
- 🖼️ Inline image display
- ✨ Modern gradient UI
- 🔄 Automatic status polling

**Try it:**
```
"generate image of a sunset over the ocean"
"create a portrait of a woman with red hair"  
"make an image of a futuristic city at night"
```

## 📦 Installation

### For New Installations

The web UI server is included automatically when you run:
```powershell
# Windows
.\install-windows.ps1

# Linux/macOS
./install-linux-macos.sh
```

The `webui/` directory will be created and the sample `ai_image.html` file will be added.

### For Existing Installations

If you already have the stack installed:

**Step 1: Update docker-compose.yml**

Add this service before the `volumes:` section:

```yaml
  # Web UI Server - Serve HTML interfaces
  webui:
    image: python:3.11-slim
    container_name: webui
    ports:
      - "8890:8890"
    volumes:
      - ./webui:/app
    working_dir: /app
    command: python -m http.server 8890
    restart: unless-stopped
    networks:
      - ai-network
    depends_on:
      - comfyui
      - ollama
```

**Step 2: Create webui directory**

```bash
# Navigate to installation directory
cd ~/ai-dev-stack  # or %USERPROFILE%\ai-dev-stack on Windows

# Create directory
mkdir webui
```

**Step 3: Download the HTML interface**

Get `ai_image.html` from the repository:
```bash
# Linux/macOS
curl -o webui/ai_image.html https://raw.githubusercontent.com/Lestat569769/ai-dev-stack-docker/main/webui/ai_image.html

# Windows PowerShell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Lestat569769/ai-dev-stack-docker/main/webui/ai_image.html" -OutFile "webui/ai_image.html"
```

**Step 4: Restart the stack**

```bash
docker compose down
docker compose up -d
```

**Step 5: Access the interface**

Open http://localhost:8890/ai_image.html in your browser!

## 🎨 Adding Your Own Interfaces

### Create Custom HTML Files

Any HTML/JavaScript/CSS file you add to the `webui/` directory will be accessible at:
```
http://localhost:8890/your-file.html
```

### Example: Simple Chat Interface

Create `webui/simple_chat.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Simple Chat</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
        }
        #messages {
            border: 1px solid #ddd;
            height: 400px;
            overflow-y: auto;
            padding: 10px;
            margin-bottom: 20px;
        }
        #input {
            width: 80%;
            padding: 10px;
        }
        button {
            padding: 10px 20px;
        }
    </style>
</head>
<body>
    <h1>Chat with Ollama</h1>
    <div id="messages"></div>
    <input type="text" id="input" placeholder="Type a message...">
    <button onclick="sendMessage()">Send</button>

    <script>
        async function sendMessage() {
            const input = document.getElementById('input');
            const messages = document.getElementById('messages');
            const message = input.value;
            
            if (!message) return;
            
            // Display user message
            messages.innerHTML += `<p><strong>You:</strong> ${message}</p>`;
            input.value = '';
            
            // Call Ollama API
            try {
                const response = await fetch('http://localhost:11434/api/generate', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({
                        model: 'phi4:latest',
                        prompt: message,
                        stream: false
                    })
                });
                
                const data = await response.json();
                messages.innerHTML += `<p><strong>AI:</strong> ${data.response}</p>`;
                messages.scrollTop = messages.scrollHeight;
                
            } catch (error) {
                messages.innerHTML += `<p style="color:red;"><strong>Error:</strong> ${error.message}</p>`;
            }
        }
        
        // Allow Enter key to send
        document.getElementById('input').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') sendMessage();
        });
    </script>
</body>
</html>
```

Save this file and access it at: http://localhost:8890/simple_chat.html

## 🔗 Connecting to Services

From your HTML interfaces, you can connect to:

| Service | URL from Browser | Purpose |
|---------|-----------------|---------|
| ComfyUI | http://localhost:8188 | Image generation |
| Ollama | http://localhost:11434 | LLM chat/text |
| n8n | http://localhost:5678 | Workflows |
| Qdrant | http://localhost:6333 | Vector search |
| Web UI | http://localhost:8890 | Your interfaces |

### Example API Calls

**Ollama (Chat):**
```javascript
fetch('http://localhost:11434/api/generate', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
        model: 'phi4:latest',
        prompt: 'Hello!',
        stream: false
    })
});
```

**ComfyUI (Generate Image):**
```javascript
fetch('http://localhost:8188/prompt', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
        prompt: { /* ComfyUI workflow JSON */ }
    })
});
```

**Qdrant (Search):**
```javascript
fetch('http://localhost:6333/collections/my_collection/points/search', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
        vector: [0.1, 0.2, 0.3...],
        limit: 10
    })
});
```

## 📚 Use Cases

### 1. **Development Dashboard**
Create a single page that shows status of all services, queue lengths, model info, etc.

### 2. **Image Gallery**
Build an interface to browse and manage generated images from ComfyUI's output folder.

### 3. **Workflow Launcher**
Create buttons that trigger specific n8n workflows via webhooks.

### 4. **RAG Interface**
Build a document search interface using Qdrant + Ollama for intelligent answers.

### 5. **Multi-Tool Interface**
Combine chat, image generation, and document search in one unified UI.

## 🔧 Development Tips

### Auto-Refresh for Development

The HTTP server doesn't auto-reload. To see changes:
1. Edit your HTML file
2. Hard refresh browser (Ctrl+F5 or Cmd+Shift+R)

### Using JavaScript Frameworks

You can build with React, Vue, etc.:

```bash
# Build your app
npm run build

# Copy to webui
cp -r build/* ~/ai-dev-stack/webui/

# Access at http://localhost:8890
```

### Debugging

Check browser console (F12) for errors. Common issues:
- CORS errors (ComfyUI should allow cross-origin)
- Connection refused (service not running)
- 404 errors (file not in webui/ directory)

## 🎯 Best Practices

### 1. **Error Handling**
Always wrap fetch calls in try-catch:
```javascript
try {
    const response = await fetch(...);
    const data = await response.json();
} catch (error) {
    console.error('API Error:', error);
    // Show user-friendly message
}
```

### 2. **Loading States**
Show loading indicators during API calls:
```javascript
button.disabled = true;
button.textContent = 'Loading...';
// ... API call ...
button.disabled = false;
button.textContent = 'Send';
```

### 3. **Responsive Design**
Make interfaces mobile-friendly:
```css
@media (max-width: 768px) {
    .container { padding: 10px; }
    .chat-input { width: 100%; }
}
```

## 🔒 Security Notes

**⚠️ Local Use Only**

This web server is for **LOCAL DEVELOPMENT** only:
- No authentication
- No HTTPS
- No rate limiting
- Full access to all services

**For production:**
1. Add nginx with authentication
2. Enable HTTPS
3. Implement CORS restrictions
4. Add rate limiting

## 📊 Service Management

### View Logs
```bash
docker compose logs -f webui
```

### Restart Service
```bash
docker compose restart webui
```

### Stop Service
```bash
docker compose stop webui
```

### Check Status
```bash
docker compose ps webui
```

## 🐛 Troubleshooting

### Can't Access http://localhost:8890
**Check service is running:**
```bash
docker compose ps webui
```

**Check logs for errors:**
```bash
docker compose logs webui
```

**Restart service:**
```bash
docker compose restart webui
```

### File Not Found (404)
- Verify file exists in `webui/` directory
- Check filename matches URL exactly (case-sensitive)
- Try accessing http://localhost:8890/ to see directory listing

### CORS Errors
- ComfyUI should have CORS enabled (`--enable-cors-header "*"`)
- Check ComfyUI is running: http://localhost:8188
- Check browser console for specific error

### Images Not Loading
- Verify ComfyUI is accessible
- Check image URLs are correct
- Look for errors in browser console

## 🚀 Next Steps

1. ✅ Access the included AI Image Generator
2. ✅ Try the example simple chat interface
3. ✅ Create your own custom interfaces
4. ✅ Integrate with n8n workflows
5. ✅ Build your perfect AI dashboard

---

## 📚 Resources

- [Python HTTP Server Docs](https://docs.python.org/3/library/http.server.html)
- [Fetch API Tutorial](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
- [ComfyUI API](https://github.com/comfyanonymous/ComfyUI/wiki/API)
- [Ollama API](https://github.com/ollama/ollama/blob/main/docs/api.md)

---

**Happy building!** 🎉

For questions, see the [main documentation](README.md) or [open an issue](https://github.com/Lestat569769/ai-dev-stack-docker/issues).
