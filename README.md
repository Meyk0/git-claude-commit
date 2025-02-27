# git-claude-commit 🤖✍️

A Git extension that uses Anthropic's Claude AI to automatically generate commit messages based on your code changes.

## Features

- 🔍 Analyzes your staged changes (`git add`) and generates descriptive commit messages
- 🤖 Powered by Claude AI (Anthropic's advanced LLM)
- ✏️ Interactive mode allows you to use, edit, or reject suggested messages
- 🔧 Highly customizable through configuration
- 🌐 Works on macOS, Linux, and Windows (WSL)
- 🔒 Automatically masks API keys, tokens, and sensitive data
- 😀 Optional emoji prefixes for more expressive commit messages

## Installation

### Prerequisites

- Git
- curl
- An API key from Anthropic

### Quick Install

```bash
curl -s https://raw.githubusercontent.com/Meyk0/git-claude-commit/main/install.sh | bash
```

### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Meyk0/git-claude-commit.git
   ```

2. Run the installation script:
   ```bash
   cd git-claude-commit
   chmod +x install.sh
   ./install.sh
   ```

3. Add your Anthropic API key when prompted, or set it up later by editing:
   ```bash
   ~/.git-claude-commit/config.json
   ```

## Usage

After you've staged your changes with `git add`, simply run:

```bash
git-claude-commit
```

The script will:
1. Analyze your staged changes
2. Generate a commit message using Claude
3. Display the suggested message
4. Let you accept it, edit it, or cancel

### Options

```bash
git claude-commit [options]

Options:
  -y, --yes           Automatically accept the generated message
  -e, --edit          Open editor to modify the generated message
  -m, --model MODEL   Specify Claude model to use
  -v, --verbose       Show detailed output
  -h, --help          Show this help message
```

```bash

# Auto-accept generated messages
git claude-commit --yes

# Force edit mode for all messages
git claude-commit --edit

# Use specific Claude model
git claude-commit --model claude-3-opus-20240229
```

## Examples

Here are some examples of commit messages generated by Claude:

| Code Changes | Generated Commit Message |
|--------------|--------------------------|
| Fixed a null pointer in user authentication | `fix: handle null userID in authentication service` |
| Added new product filtering options to UI | `feat: add category and price filters to product search` |

See [more examples](docs/EXAMPLES.md).

## Configuration

Create a `~/.git-claude-commit/config.json` file to customize behavior:

```json
{
  "api_key": "your_anthropic_api_key",
  "model": "claude-3-5-sonnet-20240620",
  "prompt_template": "Generate a commit message for these changes:\n\n{diff}\n\nFollow these conventions: {conventions}",
  "commit_conventions": "conventional commits style with type and scope",
  "max_diff_size": 20000
}
```

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Shell Support

### Fish Shell
If you're using Fish shell, git-claude-commit comes with built-in command completion support. This will be automatically installed if Fish is detected during installation.

Features:
- Tab completion for all options
- Command descriptions
- Automatic installation during setup

The installer will automatically detect Fish shell and install the necessary completions. If you need to manually install Fish shell support:

```bash
mkdir -p ~/.config/fish/functions
cp shell/fish/git-claude-commit.fish ~/.config/fish/functions/
```

Fish shell users will get:
- Command completion for all options (-y, --yes, -e, --edit, etc.)
- Option descriptions in completions
- Seamless integration with Fish's completion system