# n8n Workflows Directory

This directory contains pre-built n8n workflow templates.

## Available Workflows

### 🎨 AI Image Generator
**File:** `n8n-workflow-ai-image-generator.json`

Complete workflow that combines Ollama and ComfyUI for intelligent image generation.

**Features:**
- Natural language image requests
- Intelligent style detection (photorealistic, cartoon, painting, 3D)
- Automatic prompt enhancement
- Quality presets (draft, normal, high, ultra, extreme)
- Dimension control (square, portrait, landscape, 4K, etc.)
- Dual-mode: Image generation or regular chat

**How to Import:**
1. Open n8n at http://localhost:5678
2. Click "Workflows" → "Import from File"
3. Select `n8n-workflow-ai-image-generator.json`
4. Configure Ollama credentials (Base URL: `http://ollama:11434`)
5. Activate and test!

**Documentation:** See [N8N-WORKFLOW-GUIDE.md](../N8N-WORKFLOW-GUIDE.md)

## Creating Your Own Workflows

n8n workflows are saved as JSON files. To share yours:

1. Create your workflow in n8n
2. Test thoroughly
3. Remove any personal credentials or data
4. Export: Click workflow settings → Download
5. Add to this directory with descriptive name
6. Update this README with description
7. Submit pull request!

## Workflow Naming Convention

Use this format: `n8n-workflow-[name].json`

Examples:
- `n8n-workflow-ai-image-generator.json`
- `n8n-workflow-document-analyzer.json`
- `n8n-workflow-social-media-automation.json`

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [n8n Community Workflows](https://n8n.io/workflows/)
- [n8n Forum](https://community.n8n.io/)

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on submitting workflows.
