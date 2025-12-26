# 🌐 Web UI Directory

This directory contains custom HTML/JavaScript interfaces for interacting with the AI stack.

## 📁 What's Inside

### ai_image.html
A standalone web interface for AI image generation with real-time progress tracking.

**Features:**
- 🎨 Chat-style interface for image generation
- 📊 Real-time progress tracking
- 🖼️ Inline image display
- ✨ Beautiful gradient UI
- 🔄 Automatic polling for generation status

**How to Use:**
1. Make sure the stack is running: `docker compose up -d`
2. Open http://localhost:8890/ai_image.html in your browser
3. Type image generation requests like:
   - "generate image of a sunset over the ocean"
   - "create a portrait of a woman with red hair"
   - "make an image of a futuristic city"

**How It Works:**
- Connects directly to ComfyUI at http://localhost:8188
- Polls for generation progress every second
- Displays images as they complete
- Tracks multiple generations simultaneously

## 🎯 Adding Your Own Interfaces

You can add any HTML/JavaScript/CSS files to this directory and they'll be served at:
```
http://localhost:8890/your-file.html
```

### Example: Create a Custom Interface

**1. Create your HTML file:**
```html
<!-- custom_interface.html -->
<!DOCTYPE html>
<html>
<head>
    <title>My Custom Interface</title>
</head>
<body>
    <h1>Hello from Custom Interface!</h1>
    <script>
        // Connect to your services
        fetch('http://localhost:11434/api/tags')
            .then(r => r.json())
            .then(data => console.log('Ollama models:', data));
    </script>
</body>
</html>
```

**2. Save to:** `webui/custom_interface.html`

**3. Access at:** http://localhost:8890/custom_interface.html

## 🔗 Service URLs from Browser

When accessing from your browser:
- **ComfyUI:** http://localhost:8188
- **Ollama:** http://localhost:11434
- **n8n:** http://localhost:5678
- **Qdrant:** http://localhost:6333
- **Web UI:** http://localhost:8890

## 📝 Development Tips

### Auto-Reload During Development
The Python HTTP server doesn't auto-reload. To see changes:
1. Edit your HTML file
2. Refresh your browser (Ctrl+F5 or Cmd+Shift+R for hard refresh)

### Using with n8n
You can integrate these interfaces with n8n workflows:
- Create webhooks in n8n
- Call them from your HTML interfaces
- Build interactive AI applications

### CORS Issues?
ComfyUI is configured with `--enable-cors-header "*"` to allow cross-origin requests.
If you have issues:
1. Check browser console for errors
2. Ensure ComfyUI is running
3. Try accessing ComfyUI directly first

## 🎨 Example Interfaces You Can Build

### 1. Ollama Chat Interface
```html
<script>
async function chat(message) {
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
    return data.response;
}
</script>
```

### 2. ComfyUI Queue Monitor
```html
<script>
async function checkQueue() {
    const response = await fetch('http://localhost:8188/queue');
    const data = await response.json();
    console.log('Running:', data.queue_running);
    console.log('Pending:', data.queue_pending);
}
</script>
```

### 3. Qdrant Search Interface
```html
<script>
async function searchVectors(query) {
    const response = await fetch('http://localhost:6333/collections/my_collection/points/search', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            vector: query,  // your vector here
            limit: 10
        })
    });
    return await response.json();
}
</script>
```

## 🔒 Security Notes

**⚠️ Important:** This web server is for LOCAL USE ONLY.

- **No authentication** - Anyone on your network can access
- **No encryption** - All traffic is HTTP (not HTTPS)
- **Full access** - Can interact with all services

**For production/internet use:**
1. Add authentication (nginx with basic auth)
2. Use HTTPS (reverse proxy with SSL)
3. Implement rate limiting
4. Add CORS restrictions

## 🚀 Advanced: Static Site Generators

You can also serve static sites built with:
- **React/Vue/Angular** - Build and copy to webui/
- **Hugo/Jekyll** - Generate static files here
- **Vite/Webpack** - Build output to this directory

Example with React:
```bash
# Build your React app
npm run build

# Copy build output
cp -r build/* ~/ai-dev-stack/webui/

# Access at http://localhost:8890
```

## 📚 Resources

### Documentation:
- [Python http.server](https://docs.python.org/3/library/http.server.html)
- [ComfyUI API](https://github.com/comfyanonymous/ComfyUI/wiki/API)
- [Ollama API](https://github.com/ollama/ollama/blob/main/docs/api.md)
- [Qdrant API](https://qdrant.tech/documentation/quick-start/)

### Tutorials:
- [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
- [WebSocket API](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API)
- [Async/Await](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Asynchronous/Async_await)

## 🆘 Troubleshooting

**Problem: Can't access http://localhost:8890**
- Solution: Check webui container is running: `docker compose ps webui`
- Check logs: `docker compose logs webui`

**Problem: CORS errors in browser console**
- Solution: Check ComfyUI has CORS enabled (it should by default in docker-compose.yml)

**Problem: Images not loading**
- Solution: Check ComfyUI is running and accessible at http://localhost:8188
- Check browser console for errors
- Try accessing ComfyUI directly

**Problem: Changes not showing**
- Solution: Hard refresh your browser (Ctrl+F5 or Cmd+Shift+R)
- Clear browser cache
- Try incognito/private window

---

**Happy building! 🎉**

For more help, see the main [README.md](../README.md) or [ask in discussions](https://github.com/Lestat569769/ai-dev-stack-docker/discussions).
