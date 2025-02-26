# Contributing to git-claude-commit

Thank you for your interest in contributing to git-claude-commit! This document outlines the process for contributing to this project.

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

## How to Contribute

### Reporting Bugs

If you find a bug, please report it by opening an issue. When reporting a bug, please include:

- A clear and descriptive title
- Steps to reproduce the bug
- Expected behavior
- Actual behavior
- Your operating system and shell
- Any relevant logs or error messages

### Suggesting Enhancements

We welcome suggestions for enhancements! When suggesting an enhancement, please:

- Use a clear and descriptive title
- Describe the current behavior and explain why it needs improvement
- Explain the desired behavior
- Provide examples of how the enhancement would be used

### Pull Requests

We actively welcome pull requests:

1. Fork the repo and create your branch from `main`
2. If you've added code that should be tested, add tests
3. If you've changed functionality, update the documentation
4. Ensure your code passes any existing tests
5. Create a pull request

### Development Workflow

1. Clone your fork
2. Create a feature branch: `git checkout -b my-new-feature`
3. Make your changes and commit them: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

### Coding Style Guidelines

- Follow the existing code style
- Use meaningful variable and function names
- Add comments for complex logic
- Ensure your code is compatible with Bash 3.2+ for maximum compatibility

## Development Setup

### Prerequisites

- Git
- Bash (3.2 or higher)
- curl
- jq (recommended)

### Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/git-claude-commit.git
   cd git-claude-commit
   ```

2. Install the script in development mode:
   ```bash
   ./install.sh
   ```

3. Test your changes:
   ```bash
   git claude-commit --verbose
   ```

## Release Process

1. Update the version number in the script
2. Update the CHANGELOG.md file
3. Create a new release on GitHub with release notes

## License

By contributing, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).