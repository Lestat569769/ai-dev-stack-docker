# Contributing to AI Development Stack

Thank you for your interest in contributing! This project welcomes contributions from the community.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](../../issues)
2. If not, create a new issue with:
   - Clear title describing the bug
   - Your OS and Docker version
   - Steps to reproduce
   - Expected vs actual behavior
   - Error messages or logs
   - Screenshots if applicable

### Suggesting Enhancements

1. Check [Issues](../../issues) for existing suggestions
2. Create a new issue with:
   - Clear description of the enhancement
   - Why it would be useful
   - How it should work
   - Any implementation ideas

### Contributing Code

1. **Fork the repository**
   - Click "Fork" button on GitHub
   - Clone your fork locally

2. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Test thoroughly on multiple platforms if possible
   - Update documentation as needed

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add: brief description of changes"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**
   - Go to original repository
   - Click "New Pull Request"
   - Select your branch
   - Describe your changes
   - Link related issues

### Improving Documentation

Documentation improvements are always welcome! This includes:
- Fixing typos or unclear instructions
- Adding examples or use cases
- Improving installation guides
- Adding troubleshooting tips

### Adding Workflow Templates

If you create useful n8n workflows:
1. Test thoroughly
2. Document clearly
3. Remove any personal credentials/data
4. Submit as PR to `workflows/` directory

## Development Guidelines

### Installation Scripts
- Must work on fresh OS installations
- Include clear error messages
- Handle common failure cases
- Test on multiple platforms

### Docker Configuration
- Use official images when possible
- Document any custom builds
- Keep compose files readable
- Include resource limits where appropriate

### Documentation
- Keep README.md concise (overview only)
- Detailed guides go in separate files
- Use clear headings and structure
- Include code examples where helpful

## Code Style

### PowerShell (Windows)
- Use approved verbs (Get-, Set-, New-, etc.)
- Include parameter validation
- Add comment-based help
- Handle errors gracefully

### Bash (Linux/macOS)
- Follow Google Shell Style Guide
- Use functions for repeated code
- Include error checking
- Make scripts portable

### Docker Compose
- Use version 3.8+
- Group related services
- Use named volumes
- Include health checks

## Testing

Before submitting:
- [ ] Test installation on fresh OS
- [ ] Verify all services start correctly
- [ ] Check all URLs are accessible
- [ ] Test basic functionality
- [ ] Update documentation if needed

## Questions?

- Open a [Discussion](../../discussions) for questions
- Join community Discord/Slack (if available)
- Check existing issues and PRs

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing!** 🎉
