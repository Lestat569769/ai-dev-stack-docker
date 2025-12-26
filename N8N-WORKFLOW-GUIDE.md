# n8n Workflow Setup Guide - AI Image Generator

## Overview

This guide shows you how to set up a complete AI Image Generator workflow in n8n that combines:
- **Ollama** (phi4:latest) for intelligent prompt engineering
- **ComfyUI** for high-quality image generation
- **n8n Chat Interface** for easy interaction

## Prerequisites

- AI Development Stack installed and running
- n8n accessible at http://localhost:5678
- ComfyUI accessible at http://localhost:8188
- Ollama accessible at http://localhost:11434
- phi4:latest model downloaded

## Quick Setup (5 minutes)

### Step 1: Import the Starter Template

1. Open n8n at http://localhost:5678
2. Create an account if you haven't already
3. Click **"Workflows"** in the left sidebar
4. Click **"+ Add Workflow"** → **"Import from File"**
5. Navigate to your installation directory:
   - **Windows**: `%USERPROFILE%\ai-dev-stack\n8n\workflows\`
   - **Linux/macOS**: `~/ai-dev-stack/n8n/workflows/`
6. Select `AI-Image-Generator-Template.json`
7. Click **"Import"**

### Step 2: Configure Ollama Credentials

1. In your imported workflow, look for the "Ollama" node (or add one)
2. Click on the node to open settings
3. Under **Credentials**, click **"Create New"**
4. Select **"Ollama API"**
5. Configure:
   - **Name**: "Local Ollama"
   - **Base URL**: `http://ollama:11434` (use container name)
   - Leave other fields as default
6. Click **"Save"**

### Step 3: Test the Workflow

1. Click **"Test workflow"** at the top
2. The Chat interface should appear
3. Try these commands:
   - `"Hello"` - Should get a chat response
   - `"Generate image of a sunset"` - Should trigger image generation
4. If successful, click **"Save"** and **"Activate"**

## Full Workflow Setup (Advanced)

### Complete AI Image Generator Workflow

This advanced setup includes:
- Intelligent prompt engineering
- Style detection (photorealistic, cartoon, painting, 3D)
- Quality presets (draft, normal, high, ultra)
- Automatic dimension detection
- Image generation and display

#### Workflow Structure

```
Chat Trigger
    ↓
Check if "image" in message
    ↓─[Yes]→ Ollama (Prompt Engineer)
    │            ↓
    │        Parse JSON Response
    │            ↓
    │        Build ComfyUI Workflow
    │            ↓
    │        POST to ComfyUI
    │            ↓
    │        Wait for Completion
    │            ↓
    │        Download Image
    │            ↓
    │        Format Response
    │
    ↓─[No]──→ Ollama (Regular Chat)
                 ↓
             Format Response
```

#### Node Configuration Details

**1. Chat Trigger Node**
```
Type: Chat Trigger
Settings:
  - Mode: Public
  - Allow in Chat: Yes
  - Agent Name: "AI Image Generator"
  - Description: "Generate images with ComfyUI and chat with Ollama"
```

**2. IF Node (Contains 'image'?)**
```
Type: IF
Condition:
  - Value 1: {{ $json.chatInput.toLowerCase() }}
  - Operation: contains
  - Value 2: "image"
```

**3. Ollama Prompt Engineer Node**
```
Type: Chain LLM (LangChain)
Connected Model: Ollama
Prompt: [See detailed prompt below]
```

**4. Ollama Chat Node**
```
Type: Chain LLM (LangChain)
Connected Model: Ollama (phi4:latest)
Prompt: {{ $json.chatInput }}
```

**5. Parse JSON Node**
```
Type: Code (JavaScript)
Code:
let p;
try {
  p = JSON.parse($input.item.json.text.replace(/```json|```/g, '').trim());
} catch(e) {
  p = {positive: 'beautiful image, highly detailed', negative: 'blurry, low quality'};
}
return [{json: p}];
```

**6. Build ComfyUI Workflow Node**
```
Type: Code (JavaScript)
[See full code in template]
Builds complete ComfyUI API payload with:
  - Quality presets
  - Dimension detection
  - Style optimization
  - Seed generation
```

**7. POST to ComfyUI Node**
```
Type: HTTP Request
Method: POST
URL: http://comfyui:8188/prompt
Body: {{ JSON.stringify($json) }}
Content-Type: application/json
```

**8. Wait Node**
```
Type: Code (JavaScript)
Waits dynamically based on:
  - Image resolution
  - Number of steps
  - Quality preset
```

**9. Check History Node**
```
Type: HTTP Request
Method: GET
URL: http://comfyui:8188/history/{{ $json.promptId }}
```

**10. Extract Image Info Node**
```
Type: Code (JavaScript)
Extracts: filename, subfolder, type
```

**11. Download Image Node**
```
Type: HTTP Request
Method: GET
URL: http://comfyui:8188/view?filename={{ $json.filename }}...
Response Format: File (binary)
```

**12. Format Response Node**
```
Type: Code (JavaScript)
Creates formatted message with:
  - Embedded image
  - Generation settings
  - Download link
```

## Prompt Engineering Template

The Ollama Prompt Engineer node uses this advanced prompt:

```
You are an expert Stable Diffusion prompt engineer.

User request: {{ $json.chatInput }}

INTELLIGENT STYLE DETECTION:
- Cartoon/Anime: Rick and Morty, SpongeBob, Pokemon, etc.
- Painting: watercolor, oil painting, etc.
- 3D Render: CGI, octane render, etc.
- Photorealistic: Default for real subjects

QUALITY ENHANCEMENT (add to every prompt):
- highly detailed
- masterpiece
- professional
- sharp focus
- 8k resolution

OUTPUT FORMAT: Return ONLY valid JSON:
{
  "positive": "detailed positive prompt with quality keywords",
  "negative": "comprehensive negative prompt matching style"
}
```

## Usage Examples

### Example 1: Simple Image Request
```
User: "generate image of a sunset over mountains"

Workflow:
1. Detects "image" keyword
2. Ollama enhances: "RAW photo, professional landscape photography..."
3. ComfyUI generates photorealistic image
4. Returns embedded image with settings
```

### Example 2: Cartoon Style
```
User: "generate cartoon image of a dragon"

Workflow:
1. Detects "image" + "cartoon"
2. Ollama creates cartoon-style prompt
3. Adjusts sampler to "euler" for cartoon
4. Returns vibrant cartoon image
```

### Example 3: Quality Control
```
User: "generate high quality 1024 portrait image of a woman"

Workflow:
1. Detects: "high quality" → 50 steps
2. Detects: "1024" → 1024x1024 resolution
3. Detects: "portrait" → portrait orientation
4. Generates ultra-high quality result
```

### Example 4: Regular Chat
```
User: "what's the weather like today?"

Workflow:
1. No "image" keyword detected
2. Routes to chat-only path
3. Ollama responds conversationally
4. No image generation triggered
```

## Customization Options

### Add More Models

Edit the "Build ComfyUI Workflow" node:
```javascript
const models = {
  'default': 'v1-5-pruned-emaonly.safetensors',
  'dreamshaper': 'dreamshaper_8.safetensors',
  'realistic': 'realisticVision.safetensors',
  'anime': 'anythingV5.safetensors'
};
```

### Add Custom Quality Presets

```javascript
const qualityPresets = {
  'draft': { steps: 20, cfg: 6.5 },
  'normal': { steps: 35, cfg: 6.5 },
  'high': { steps: 50, cfg: 6.5 },
  'ultra': { steps: 70, cfg: 7.0 },
  'insane': { steps: 150, cfg: 7.5 }  // Add this
};
```

### Add Custom Dimensions

```javascript
const aspectRatios = {
  'instagram': { width: 1080, height: 1080 },
  'story': { width: 1080, height: 1920 },
  'banner': { width: 1920, height: 1080 },
  'thumbnail': { width: 1280, height: 720 }
};
```

## Troubleshooting

### Workflow Won't Execute
- Check all nodes are connected
- Verify Ollama credentials
- Ensure ComfyUI is running: `docker compose ps`

### Images Not Generating
- Check ComfyUI logs: `docker compose logs comfyui`
- Verify models are in `comfyui/models/checkpoints/`
- Test ComfyUI directly at http://localhost:8188

### Ollama Connection Failed
- Verify Ollama is running: `docker compose ps`
- Check URL is `http://ollama:11434` (not localhost)
- Test: `docker exec -it ollama ollama list`

### Slow Generation
- Reduce steps in quality presets
- Use smaller dimensions
- Check CPU/GPU usage
- Ensure GPU support is enabled (if available)

### Wrong Image Style
- Review Ollama prompt engineering
- Check style detection logic
- Manually specify style in request
- Example: "generate photorealistic image..."

## Best Practices

### 1. Always Specify Style
```
Good: "generate photorealistic portrait of a woman"
Bad: "generate image of a woman"
```

### 2. Be Specific with Details
```
Good: "anime girl with blue hair, red dress, happy expression"
Bad: "anime girl"
```

### 3. Use Quality Keywords
```
- "high quality" → triggers high preset
- "ultra" → triggers ultra preset
- "1024" → sets resolution to 1024x1024
```

### 4. Test Incrementally
- Start with "draft" quality
- Verify prompt works
- Increase quality for final version

### 5. Monitor Resources
- Check Docker Desktop resource usage
- One image at a time for stability
- Close unused applications

## Advanced Features

### Batch Generation
Add a loop node to generate multiple variations:
```javascript
for (let i = 0; i < 4; i++) {
  // Change seed each iteration
  seed: Math.floor(Math.random() * 999999)
}
```

### Upscaling
Add an upscaler node after generation:
```javascript
{
  "inputs": {
    "upscale_model": "RealESRGAN_x4plus.pth",
    "image": ["8", 0]
  },
  "class_type": "ImageUpscaleWithModel"
}
```

### ControlNet
Add pose/depth control:
```javascript
{
  "inputs": {
    "control_net_name": "control_v11p_sd15_openpose.pth",
    "image": ["preprocessor", 0]
  },
  "class_type": "ControlNetLoader"
}
```

## Export and Share

### Export Your Workflow
1. Click workflow settings (⚙️)
2. Select "Download"
3. Saves as JSON file
4. Share with others!

### Import Others' Workflows
1. Visit n8n.io/workflows
2. Download community workflows
3. Import into your n8n instance
4. Customize as needed

## Next Steps

1. ✅ Import and test the starter workflow
2. 📚 Read the complete prompt engineering guide
3. 🎨 Download more Stable Diffusion models
4. 🤖 Experiment with different Ollama models
5. 🔄 Create custom workflows for your use case
6. 🚀 Build automation pipelines

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [ComfyUI Examples](https://comfyanonymous.github.io/ComfyUI_examples/)
- [Ollama Model Library](https://ollama.com/library)
- [Stable Diffusion Prompt Guide](https://stable-diffusion-art.com/prompt-guide/)

## Community

- [n8n Community Forum](https://community.n8n.io/)
- [ComfyUI Discord](https://discord.gg/comfyui)
- [Ollama Discord](https://discord.gg/ollama)

---

**Happy Automating! 🎨🤖**
