# 🔄 n8n AI Image Generator Workflow - Complete Guide

## 📖 Table of Contents

1. [Overview](#overview)
2. [What This Workflow Does](#what-this-workflow-does)
3. [Visual Architecture](#visual-architecture)
4. [Node-by-Node Breakdown](#node-by-node-breakdown)
5. [How Data Flows](#how-data-flows)
6. [Customization Guide](#customization-guide)
7. [Advanced Modifications](#advanced-modifications)
8. [Troubleshooting](#troubleshooting)

---

## Overview

The **AI Image Generator Workflow** is a production-ready n8n workflow that combines:
- **Ollama** (LLM) for intelligent prompt engineering
- **ComfyUI** (Stable Diffusion) for image generation
- **Smart routing** for dual-mode operation (images + chat)

**What makes it special:**
- ✅ Automatic style detection (photorealistic, cartoon, painting, 3D)
- ✅ Intelligent prompt enhancement using AI
- ✅ Quality and dimension control through natural language
- ✅ Dual-mode: Can generate images OR have regular conversations
- ✅ Production-ready error handling

---

## What This Workflow Does

### User Experience

**When you say:** "generate image of a sunset over mountains"

**What happens:**
1. 🔍 Workflow detects "image" keyword
2. 🤖 Ollama analyzes your request and creates an enhanced prompt
3. 🎨 Detects style (photorealistic for realistic landscape)
4. ⚙️ Builds optimized ComfyUI workflow
5. 🖼️ Generates the image
6. 📥 Downloads and returns it to you

**Time:** ~18-40 seconds depending on quality settings

### Intelligent Features

#### 1. Style Auto-Detection

The workflow automatically recognizes different styles:

| Your Input | Detected Style | Result |
|------------|----------------|---------|
| "Rick and Morty" | Cartoon (by character name) | Vibrant cartoon with bold outlines |
| "portrait of a woman" | Photorealistic | Professional photography style |
| "painting of mountains" | Artistic/Painting | Oil painting with brush strokes |
| "3D render of robot" | 3D/CGI | Realistic 3D materials and lighting |
| "anime girl" | Anime | Japanese animation style |

#### 2. Quality Control Keywords

| Keyword in Request | Steps Used | Time | Quality |
|-------------------|------------|------|---------|
| "quick" or "draft" | 20 steps | ~10s | Fast preview |
| (default) | 35 steps | ~18s | Good balance |
| "high quality" | 50 steps | ~28s | High detail |
| "ultra" | 70 steps | ~38s | Maximum quality |
| "extreme" | 100 steps | ~55s | Best possible |

#### 3. Dimension Detection

| Keyword | Resolution | Best For |
|---------|-----------|----------|
| "portrait" | 512x768 | Vertical photos |
| "landscape" | 768x512 | Horizontal scenes |
| "square" | 512x512 | Social media |
| "1024" | 1024x1024 | High resolution |
| "4k" | 2048x2048 | Print quality |
| "phone" | 480x853 | Mobile wallpapers |
| "wide" | 1024x512 | Banners |

#### 4. Dual-Mode Operation

**Image Mode:** (Contains "image")
```
User: "generate image of a cat"
→ Full AI image generation pipeline
```

**Chat Mode:** (No "image")
```
User: "what is the weather like?"
→ Regular conversation with Ollama
```

---

## Visual Architecture

### Complete Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER INPUT                                │
│                  "generate image of X"                           │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│  NODE 1: Chat Trigger                                            │
│  • Receives user message                                         │
│  • Provides chat interface                                       │
│  • Outputs: { chatInput: "user message" }                        │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│  NODE 2: Contains 'image'? (IF Node)                             │
│  • Checks if message contains "image"                            │
│  • Routes to appropriate path                                    │
└────────────┬────────────────────────────────────┬───────────────┘
             ↓ YES                                 ↓ NO
    [IMAGE GENERATION PATH]              [CHAT PATH]
             ↓                                     ↓
┌────────────────────────────┐         ┌──────────────────────┐
│ NODE 3: AI Prompt Engineer │         │ NODE 11: Chat        │
│ (Ollama - qwen2.5)         │         │ (Ollama - phi4)      │
│ • Analyzes user request    │         │ • Normal conversation│
│ • Detects style intent     │         │ • Helpful responses  │
│ • Enhances prompt          │         └──────────┬───────────┘
│ • Creates JSON output      │                    ↓
│   {positive: "...",        │         ┌──────────────────────┐
│    negative: "..."}        │         │ NODE 12: Format      │
└────────────┬───────────────┘         │ • Formats response   │
             ↓                          └──────────┬───────────┘
┌────────────────────────────┐                    ↓
│ NODE 4: Parse JSON         │              [RETURN TO USER]
│ • Extracts positive prompt │
│ • Extracts negative prompt │
│ • Error handling           │
└────────────┬───────────────┘
             ↓
┌────────────────────────────┐
│ NODE 5: Build ComfyUI API  │
│ • Detects quality keywords │
│ • Detects dimension needs  │
│ • Detects model preference │
│ • Builds workflow JSON     │
│ • Calculates wait time     │
└────────────┬───────────────┘
             ↓
┌────────────────────────────┐
│ NODE 6: POST to ComfyUI    │
│ • Sends prompt to ComfyUI  │
│ • Receives prompt_id       │
└────────────┬───────────────┘
             ↓
┌────────────────────────────┐
│ NODE 7: Store Metadata     │
│ • Saves prompt_id          │
│ • Saves generation settings│
│ • Saves calculated wait    │
└────────────┬───────────────┘
             ↓
┌────────────────────────────┐
│ NODE 8: Dynamic Wait       │
│ • Waits based on quality   │
│ • 10s for draft            │
│ • 18s for normal           │
│ • 28s for high             │
│ • 38s+ for ultra/extreme   │
└────────────┬───────────────┘
             ↓
┌────────────────────────────┐
│ NODE 9: Check History      │
│ • Polls ComfyUI /history   │
│ • Checks if image ready    │
└────────────┬───────────────┘
             ↓
┌────────────────────────────┐
│ NODE 10: Extract Image Info│
│ • Gets filename            │
│ • Gets subfolder           │
│ • Gets type                │
└────────────┬───────────────┘
             ↓
┌────────────────────────────┐
│ NODE 11: Download Image    │
│ • Fetches image from URL   │
│ • Returns binary data      │
└────────────┬───────────────┘
             ↓
┌────────────────────────────┐
│ NODE 13: Format Response   │
│ • Creates formatted message│
│ • Embeds image             │
│ • Shows settings used      │
└────────────┬───────────────┘
             ↓
       [RETURN TO USER]
```

---

## Node-by-Node Breakdown

### NODE 1: Chat Trigger
**Type:** `@n8n/n8n-nodes-langchain.chatTrigger`

**Purpose:** Entry point for all user messages

**Configuration:**
```javascript
{
  public: true,
  availableInChat: true,
  agentName: "AI Image Generator",
  agentDescription: "Generate images with ComfyUI and chat with Ollama"
}
```

**Output:**
```json
{
  "chatInput": "user's message here",
  "sessionId": "unique-session-id"
}
```

**What to modify:**
- `agentName` - Change the chat bot's name
- `agentDescription` - Change what users see as description

---

### NODE 2: Contains 'image'?
**Type:** `n8n-nodes-base.if`

**Purpose:** Smart routing between image generation and chat

**Logic:**
```javascript
if (chatInput.toLowerCase().contains("image")) {
  → Go to AI Prompt Engineer (IMAGE PATH)
} else {
  → Go to Chat Node (CHAT PATH)
}
```

**What to modify:**
- Change detection keyword from "image" to something else
- Add multiple keywords: "image" OR "picture" OR "generate"
- Make it case-sensitive if needed

**Example modification:**
```javascript
// Multiple keywords
chatInput.toLowerCase().match(/image|picture|photo|generate|create/)

// More specific
chatInput.toLowerCase().includes("generate image")
```

---

### NODE 3: AI Prompt Engineer
**Type:** `@n8n/n8n-nodes-langchain.chainLlm`  
**Model:** Ollama (qwen2.5:latest)

**Purpose:** Transforms user requests into optimized Stable Diffusion prompts

**Input:** User's raw request
**Output:** JSON with positive and negative prompts

**The Prompt (2000+ words):**
This node uses a massive prompt that teaches the AI how to:
1. Detect style intent (photorealistic, cartoon, anime, painting, 3D)
2. Add quality enhancement keywords
3. Create comprehensive positive prompts
4. Create style-appropriate negative prompts
5. Handle edge cases

**Example transformation:**
```
Input: "generate image of Rick and Morty"

AI Output:
{
  "positive": "digital illustration of Rick and Morty from the 
              animated series, cartoon style, vibrant colors, 
              bold outlines, cel shaded, Rick with spiky blue hair, 
              white lab coat, cynical expression, Morty with yellow 
              shirt, brown hair, nervous expression, animated style, 
              clean lines, expressive faces, highly detailed, 
              masterpiece, professional cartoon art, sharp focus, 4k",
  
  "negative": "photorealistic, realistic, RAW photo, photograph, 
              3D render, blurry, low quality, low resolution, 
              pixelated, distorted, deformed, ugly, bad anatomy, 
              bad proportions, wrong colors"
}
```

**What to modify:**
- Change the model: Replace `qwen2.5:latest` with `phi4:latest` or other
- Adjust the prompt engineering instructions
- Add your own style categories
- Customize quality keywords

---

### NODE 4: Parse JSON
**Type:** `n8n-nodes-base.code` (JavaScript)

**Purpose:** Safely extract prompts from AI response

**Code:**
```javascript
let p;
try {
  // Remove markdown code fences if AI added them
  p = JSON.parse($input.item.json.text.replace(/```json|```/g, '').trim());
} catch(e) {
  // Fallback if parsing fails
  p = {
    positive: 'beautiful image, highly detailed', 
    negative: 'blurry, low quality'
  };
}
return [{json: p}];
```

**What to modify:**
- Change fallback prompts
- Add validation logic
- Log errors for debugging

---

### NODE 5: Build ComfyUI API
**Type:** `n8n-nodes-base.code` (JavaScript)

**Purpose:** Creates the complete ComfyUI API payload

**This is the BRAIN of the workflow!**

**What it does:**
1. **Reads prompts** from previous node
2. **Detects quality keywords** in user's original message
3. **Detects dimension keywords**
4. **Detects model preferences**
5. **Applies style-specific settings** (sampler, CFG)
6. **Builds ComfyUI workflow JSON**
7. **Calculates wait time**

**Quality Presets:**
```javascript
const qualityPresets = {
  'draft': { steps: 20, cfg: 6.5, sampler: 'dpm_2' },
  'normal': { steps: 35, cfg: 6.5, sampler: 'dpm_2' },
  'high': { steps: 50, cfg: 6.5, sampler: 'dpm_2' },
  'ultra': { steps: 70, cfg: 7.0, sampler: 'dpm_2' },
  'extreme': { steps: 100, cfg: 7.0, sampler: 'dpm_2' }
};
```

**Dimension Presets:**
```javascript
const aspectRatios = {
  'square': { width: 512, height: 512 },
  'portrait': { width: 512, height: 768 },
  'landscape': { width: 768, height: 512 },
  '1024': { width: 1024, height: 1024 },
  '4k': { width: 2048, height: 2048 }
};
```

**Style Detection:**
```javascript
// Cartoon/Anime
if (userRequest.includes('cartoon') || userRequest.includes('anime')) {
  quality.cfg = 11.0;  // Higher CFG for stronger style
  quality.sampler = 'euler';  // Better for cartoons
}

// Photorealistic
if (!isCartoon && !isArtistic && !is3D) {
  quality.cfg = 6.5;  // Lower CFG for realism
  quality.sampler = 'dpm_2';  // Better for photos
  // Add photorealism keywords
}
```

**What to modify:** (See Customization section below)

---

### NODE 6: POST to ComfyUI
**Type:** `n8n-nodes-base.httpRequest`

**Purpose:** Sends the workflow to ComfyUI

**Configuration:**
```javascript
{
  method: "POST",
  url: "http://comfyui:8188/prompt",
  contentType: "application/json",
  body: "{{ JSON.stringify($json) }}"
}
```

**Response:**
```json
{
  "prompt_id": "unique-id-12345",
  "number": 1
}
```

**What to modify:**
- Change URL if ComfyUI is on different host
- Add authentication headers if needed

---

### NODE 7: Store Metadata
**Type:** `n8n-nodes-base.set`

**Purpose:** Saves important data for later nodes

**Stores:**
- `promptId` - To check generation status
- `metadata` - Settings used (dimensions, steps, etc.)
- `waitTime` - How long to wait

---

### NODE 8: Dynamic Wait
**Type:** `n8n-nodes-base.code`

**Purpose:** Waits for image to generate

**Logic:**
```javascript
const waitTime = $input.item.json.waitTime || 25;
await new Promise(resolve => setTimeout(resolve, waitTime * 1000));
return [$input.item];
```

**Calculation in Node 5:**
```javascript
let waitTime = 8;  // Base time

// Adjust for quality
if (steps <= 25) waitTime = 10;
else if (steps <= 40) waitTime = 18;
else if (steps <= 55) waitTime = 28;
else if (steps <= 75) waitTime = 38;
else waitTime = 55;

// Adjust for resolution
const totalPixels = width * height;
if (totalPixels >= 2097152) waitTime += 30;  // 4K
else if (totalPixels >= 1048576) waitTime += 18;  // 1024
else if (totalPixels >= 589824) waitTime += 10;  // 768
```

---

### NODE 9-11: Image Retrieval
**Purpose:** Get the generated image

**Flow:**
1. Check history endpoint for completion
2. Extract image filename and path
3. Download the actual image file

---

### NODE 13: Format Response
**Type:** `n8n-nodes-base.code`

**Purpose:** Create user-friendly response with image

**Output:**
```markdown
✨ **Image Generated Successfully!**

![Generated Image](http://localhost:8188/view?filename=...)

**Filename:** image_12345.png

**Settings:**
- Dimensions: 768x512 (Landscape)
- Steps: 35
- CFG: 6.5
- Sampler: dpm_2
- Model: v1-5-pruned-emaonly.safetensors
- Seed: 123456

🎨 Your AI-generated image is ready!
```

---

## How Data Flows

### Example: "generate high quality portrait image of a woman"

**Step-by-step data:**

```javascript
// 1. Chat Trigger Output
{
  chatInput: "generate high quality portrait image of a woman"
}

// 2. IF Node - Contains "image"? YES → IMAGE PATH

// 3. AI Engineer Output
{
  text: '{"positive": "RAW photo, professional portrait photography...", 
         "negative": "blurry, low quality, cartoon..."}'
}

// 4. Parse Output
{
  positive: "RAW photo, professional portrait photography of a woman, natural lighting, photorealistic, detailed facial features...",
  negative: "blurry, low quality, cartoon, anime, illustration..."
}

// 5. Build ComfyUI Output
{
  prompt: { /* Complete ComfyUI workflow */ },
  metadata: {
    dimensions: "Portrait 512x768",
    steps: 50,  // "high quality" detected
    cfg: 6.5,
    sampler: "dpm_2",
    waitTime: 28
  }
}

// 6. POST Response
{
  prompt_id: "abc123def456"
}

// 7. Store Output
{
  promptId: "abc123def456",
  metadata: { /* settings */ },
  waitTime: 28
}

// 8. Dynamic Wait (pauses 28 seconds)

// 9. Check History Response
{
  "abc123def456": {
    outputs: {
      "9": {
        images: [{
          filename: "ComfyUI_00001_.png",
          subfolder: "",
          type: "output"
        }]
      }
    }
  }
}

// 10. Extract Output
{
  filename: "ComfyUI_00001_.png",
  subfolder: "",
  type: "output"
}

// 11. Download (binary image data)

// 13. Format Response (markdown + image)
```

---

## Customization Guide

### 1. Add New Quality Presets

**Location:** NODE 5 (Build ComfyUI API)

```javascript
// Find this section:
const qualityPresets = {
  'draft': { steps: 20, cfg: 6.5, sampler: 'dpm_2', scheduler: 'karras' },
  'normal': { steps: 35, cfg: 6.5, sampler: 'dpm_2', scheduler: 'karras' },
  'high': { steps: 50, cfg: 6.5, sampler: 'dpm_2', scheduler: 'karras' },
  'ultra': { steps: 70, cfg: 7.0, sampler: 'dpm_2', scheduler: 'karras' },
  'extreme': { steps: 100, cfg: 7.0, sampler: 'dpm_2', scheduler: 'karras' }
};

// ADD YOUR OWN:
const qualityPresets = {
  // ... existing presets ...
  'lightning': { steps: 15, cfg: 5.0, sampler: 'euler_a', scheduler: 'simple' },  // Super fast
  'professional': { steps: 60, cfg: 7.5, sampler: 'dpm_2', scheduler: 'karras' }, // Studio quality
  'maximum': { steps: 150, cfg: 8.0, sampler: 'dpm_2', scheduler: 'karras' }      // Best possible
};

// Then add detection:
if (userRequest.includes('lightning') || userRequest.includes('fastest')) {
  quality = qualityPresets['lightning'];
}
```

### 2. Add Custom Dimensions

```javascript
// Find aspectRatios object
const aspectRatios = {
  // ... existing ...
  'instagram': { width: 1080, height: 1080, desc: 'Instagram Square' },
  'story': { width: 1080, height: 1920, desc: 'Instagram Story' },
  'youtube': { width: 1920, height: 1080, desc: 'YouTube Thumbnail' },
  'twitter': { width: 1200, height: 675, desc: 'Twitter Card' }
};

// Add detection
if (userRequest.includes('instagram') && userRequest.includes('story')) {
  dimensions = aspectRatios['story'];
}
```

### 3. Add Different Models

```javascript
const models = {
  'default': 'v1-5-pruned-emaonly.safetensors',
  'v15': 'v1-5-pruned-emaonly.safetensors',
  'dreamshaper': 'dreamshaper_8.safetensors',
  'realistic': 'realisticVision.safetensors',
  'anime': 'anythingV5.safetensors',
  'artistic': 'deliberate_v2.safetensors'
};

// Detection
if (userRequest.includes('dreamshaper')) {
  model = models['dreamshaper'];
} else if (userRequest.includes('realistic')) {
  model = models['realistic'];
}
```

### 4. Change Detection Keywords

**Location:** NODE 2 (IF condition)

```javascript
// Current: Only detects "image"
chatInput.toLowerCase().includes("image")

// Change to multiple keywords:
chatInput.toLowerCase().match(/image|picture|photo|draw|generate|create/)

// More specific:
chatInput.toLowerCase().includes("generate image") || 
chatInput.toLowerCase().includes("create picture")
```

### 5. Switch LLM Models

**Option A: Different model for prompt engineering**
- NODE 3: Change `qwen2.5:latest` to `phi4:latest` or `llama3.2`

**Option B: Different model for chat**
- NODE 11 (Chat): Change `phi4:latest` to your preferred model

### 6. Adjust Wait Times

**Make it wait longer:**
```javascript
// In Build Enhanced node, multiply wait times:
waitTime = waitTime * 1.5;  // 50% longer
```

**Make it faster (risky):**
```javascript
waitTime = waitTime * 0.8;  // 20% shorter
```

### 7. Add LoRA Support

```javascript
// In Build Enhanced node, add to positive prompt:
let lora = "";
if (userRequest.includes('anime style')) {
  lora = "<lora:anime_style:0.8> ";
}
enhancedPositive = lora + enhancedPositive;
```

### 8. Add Negative Prompt Presets

```javascript
const negativePresets = {
  'realistic': 'cartoon, anime, illustration, painting, sketch, drawing, CGI, 3D render',
  'cartoon': 'photorealistic, realistic, photograph, RAW photo, 3D render',
  'artistic': 'photorealistic, photograph, cartoon, anime, 3D render',
  'nsfw_block': 'nsfw, nude, explicit, sexual content, violence, gore, disturbing'
};

// Apply:
enhancedNegative += ', ' + negativePresets['nsfw_block'];
```

---

## Advanced Modifications

### 1. Add Image-to-Image Support

Add a new IF node after Chat Trigger:
```javascript
// Check if user attached an image
if ($json.files && $json.files.length > 0) {
  → Go to Image-to-Image path
}
```

### 2. Add Model Auto-Selection

Based on prompt content:
```javascript
// Auto-select best model for content
if (positive.includes('person') || positive.includes('portrait')) {
  model = 'realisticVision.safetensors';  // Best for people
} else if (positive.includes('landscape') || positive.includes('nature')) {
  model = 'dreamshaper_8.safetensors';  // Best for landscapes
} else if (positive.includes('anime') || positive.includes('cartoon')) {
  model = 'anythingV5.safetensors';  // Best for anime
}
```

### 3. Add Batch Generation

```javascript
// Generate multiple variations
const batchSize = 4;
const seeds = [];
for (let i = 0; i < batchSize; i++) {
  seeds.push(Math.floor(Math.random() * 999999));
}

// Send multiple requests with different seeds
```

### 4. Add Upscaling

After image generation, add nodes:
1. HTTP Request to ComfyUI upscale endpoint
2. Wait node
3. Download upscaled image

### 5. Add History/Gallery

Store generated images in a database:
```javascript
// Add after Format Response
{
  prompt: userRequest,
  image_url: imageUrl,
  settings: metadata,
  timestamp: new Date(),
  user_id: sessionId
}
```

### 6. Add Safety Filters

Before generation:
```javascript
// Block inappropriate content
const blockedWords = ['violence', 'gore', 'nsfw'];
if (blockedWords.some(word => userRequest.includes(word))) {
  return [{json: {error: "Content not allowed"}}];
}
```

---

## Troubleshooting

### Problem: Workflow doesn't detect "image" keyword

**Solution:**
- Check NODE 2 (IF condition)
- Make sure comparison is case-insensitive: `toLowerCase()`
- Try exact match in test mode

### Problem: AI returns malformed JSON

**Solution:**
- NODE 4 (Parse) has fallback handling
- Check Ollama model is responding correctly
- Try different model (phi4, llama3.2)

### Problem: Images taking too long

**Solutions:**
1. Reduce steps in quality presets
2. Use smaller dimensions
3. Check GPU is enabled
4. Use faster sampler: `euler_a` instead of `dpm_2`

### Problem: Low quality images

**Solutions:**
1. Increase steps (50-70)
2. Use better model (dreamshaper, realistic vision)
3. Enhance positive prompt with more details
4. Check CFG scale (6.5-8.0 is good range)

### Problem: Style not detected correctly

**Solution:**
- Modify AI Engineer prompt (NODE 3)
- Add more examples for your use case
- Adjust detection logic in Build Enhanced (NODE 5)

### Problem: ComfyUI connection failed

**Solutions:**
1. Check ComfyUI is running: `docker compose ps`
2. Verify URL: `http://comfyui:8188` (Docker network)
3. Test manually: `curl http://comfyui:8188/api/prompt`
4. Check logs: `docker compose logs comfyui`

---

## Next Steps

1. **Import the workflow** - See [main README](README.md)
2. **Test with examples** - Try the examples from this guide
3. **Customize** - Start with simple changes (quality presets)
4. **Experiment** - Try different models and settings
5. **Share** - Contribute improvements back to the community!

---

**Need more help?**
- [n8n Documentation](https://docs.n8n.io/)
- [ComfyUI Examples](https://comfyanonymous.github.io/ComfyUI_examples/)
- [Repository Issues](https://github.com/Lestat569769/ai-dev-stack-docker/issues)

**Happy automating! 🎨🤖**
