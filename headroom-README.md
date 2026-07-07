# headroom (`max`) — Installation & Usage Guide

`headroom` is an AI-powered interactive REPL (terminal agent) that translates natural language requests into shell commands and tool calls, executing them with user confirmation.

---

## Prerequisites

- **Python 3.11+** (Python 3.12+ preferred; the package uses modern type syntax)
- **pyenv** (recommended for managing Python versions)

Check available versions:
```bash
pyenv versions
```

---

## Installation

### 1. Install under Python 3.11 or later

```bash
PYENV_VERSION=3.11.7 pip install headroom
```

> **Note:** Installing under Python 3.8 will fail with a `TypeError` due to `dict | None` union type syntax introduced in Python 3.10.

### 2. Patch for Python 3.11 compatibility (if needed)

`headroom 0.2.7` contains f-strings with nested double quotes (`f"...{result["key"]}..."`) that require Python 3.12+. If running on 3.11, patch the four affected lines in `system_tools.py`:

```bash
SITE_PACKAGES=~/.pyenv/versions/3.11.7/lib/python3.11/site-packages/headroom
```

In `system_tools.py`, replace any occurrence of `{result["output"]}` inside an f-string with `{result['output']}` (single quotes inside the braces).

The patched lines (around lines 330, 332, 349, 351) should read:
```python
return {"success": False, "output": f"Failed to parse CPU usage: {e}. Raw output: {result['output']}"}
return {"success": False, "output": f"Failed to get CPU usage: {result['output']}"}
return {"success": False, "output": f"Failed to parse memory usage: {e}. Raw output: {result['output']}"}
return {"success": False, "output": f"Failed to get memory usage: {result['output']}"}
```

### 3. (Optional) Add to PATH

To use `max` directly without the full path, add to `~/.zshrc`:

```bash
export PATH="$HOME/.pyenv/versions/3.11.7/bin:$PATH"
```

Then reload:
```bash
source ~/.zshrc
```

---

## Running the REPL

```bash
~/.pyenv/versions/3.11.7/bin/max
# or, if added to PATH:
max
```

### First-run setup

On first launch, `max` runs an interactive setup wizard to configure your LLM provider. It saves credentials to:

```
~/.config/headroom/.env
```

Supported providers include **Anthropic (Claude)**, **Ollama**, and others. To reconfigure later, type `config` at the `Max>` prompt.

---

## REPL Commands

Once at the `Max>` prompt:

| Command       | Description                                              |
|---------------|----------------------------------------------------------|
| `help`        | Show all available commands                              |
| `config`      | Reconfigure the LLM provider and model settings          |
| `tools`       | List all built-in tools and their descriptions           |
| `log`         | Display the Max agent log file                           |
| `revoke`      | Manage commands previously set to "always allow"         |
| `exit`/`quit` | Exit the REPL                                            |

---

## Usage

Type any natural language request at the `Max>` prompt. Max will:

1. Interpret your intent (locally or via LLM)
2. Propose a shell command or tool action
3. Ask for confirmation before executing

**Example interactions:**

```
Max> what is the current directory
Max> list all Python files in this folder
Max> show disk usage
Max> create a file called notes.txt
```

### Confirmation options

When Max proposes an action:
- `1` — Allow once
- `2` — Always allow this command category
- `3` — Cancel

### Direct shell commands

Recognised shell commands (e.g. `ls`, `grep`, `cat`) are detected automatically and executed with confirmation — no need to phrase them in natural language.

### Sudo commands

`sudo` commands are intercepted and require explicit confirmation before execution.

---

## Built-in Tools

Access the full tool list with `tools` inside the REPL. Categories include:

- **File operations** — read, write, update JSON/YAML/.env files
- **Directory operations** — list, search, glob, copy, move, delete
- **Git** — `git status`, `git diff`, `git commit`
- **System info** — CPU usage, memory usage (Linux only)
- **Package management** — install/remove/search via apt, yum, dnf, snap, flatpak (Linux only)
- **Script execution** — create and run Python scripts

---

## Log File

Max logs all activity to:

```
~/.local/share/headroom/max_agent.log   # Linux/macOS (XDG)
```

View logs from inside the REPL with `log`, or directly:

```bash
cat "$(python3 -c 'from headroom.utils import get_user_data_dir; print(get_user_data_dir())')/max_agent.log"
```

---

## Troubleshooting

### `zsh: command not found: headroom`
The CLI entry point is `max`, not `headroom`. Use `~/.pyenv/versions/3.11.7/bin/max` or add the bin directory to your PATH.

### `TypeError: unsupported operand type(s) for |`
You are running Python 3.8. Install headroom under Python 3.10+ (see Installation above).

### `SyntaxError: f-string: unmatched '['`
You are running Python 3.11. Apply the f-string patch described in step 2 of Installation.

### LLM provider not responding
Run `config` at the `Max>` prompt to re-enter your API key or switch providers.

---

## Uninstalling

```bash
PYENV_VERSION=3.11.7 pip uninstall headroom
```

---

## Repository Contents

This repository tracks the development environment configuration alongside the headroom documentation.

| File | Description |
|------|-------------|
| `headroom-README.md` | This file — headroom/max install & usage guide |
| `CLAUDE.md` | Claude Code behavioral rules, swarm config, and MCP tool reference |
| `AGENTS.md` | Codex agent environment context and active project summary |
| `.mcp.json` | MCP server configuration (claude-flow v3, hierarchical-mesh topology) |
| `.npmrc` | npm settings (`ignore-scripts=true`) |
| `.gitconfig` | Git user configuration |
| `.zshrc` | Zsh shell environment (PATH, aliases, pyenv init) |
| `.zprofile` | Zsh login profile |
| `.semgrepignore` | Semgrep static analysis ignore patterns |
| `.gitignore` | Excludes credentials, caches, and unrelated project directories |

### What is excluded

The `.gitignore` explicitly excludes:
- **Credentials**: `.env`, `.ssh/`, `.aws/`, `.netrc`
- **Session state**: `.claude.json`, `.zsh_history`
- **Large runtimes**: `.pyenv/`, `.npm/`, `.ollama/`, `.cache/`
- **App data**: `.docker/`, `.warp/`, `.BurpSuite/`, `.n8n/`
- **macOS system**: `.DS_Store`, `Library/`, `Desktop/`, etc.
- **Other projects**: `autoresearch-mlx/`, `radius360/`, `vorim-project/`, etc.

---

## Skills Setup

[skills](https://skills.sh) is a package manager for AI agent skill prompts. It was installed alongside headroom to manage cybersecurity skills for Claude Code.

### Installation

```bash
brew install skills
skills --version   # 1.5.14
```

### Installed skill packages

```bash
# 817 cybersecurity skills from mukul975/Anthropic-Cybersecurity-Skills
skills add mukul975/Anthropic-Cybersecurity-Skills -g -y

# List all installed skills
skills ls -g
```

### Using a skill with Claude Code

```bash
# Pipe a skill prompt directly to claude
skills use ~/.agents/skills/<skill-name> | claude --print "<your question>"

# Example
skills use ~/.agents/skills/analyzing-threat-actor-ttps-with-mitre-attack \
  | claude --print "Summarise how to map threat actor TTPs using MITRE ATT&CK"
```

> **Note:** If `ANTHROPIC_API_KEY` is set in your shell to an invalid value, the pipe syntax will fail with "Invalid API key". Remove the export from `~/.zshrc` and run `unset ANTHROPIC_API_KEY` in the current session to use your claude.ai login instead.

### Finding skills

```bash
skills find                          # interactive search
skills find "threat intelligence"    # keyword search
skills ls -g | grep -i "vuln"        # filter installed skills
```

---

## Environment Summary

| Component | Version / Detail |
|-----------|------------------|
| OS | macOS (arm64) |
| Shell | zsh 5.9 |
| Python (active) | 3.11.7 via pyenv |
| Node.js | 25.8.1 |
| headroom | 0.2.7 (patched for Python 3.11) |
| skills | 1.5.14 |
| Claude Code | 2.1.187 |
| gh CLI | 2.91.0 |
| Installed skill packages | mukul975/Anthropic-Cybersecurity-Skills (817 skills) |
| Skills target agent | Claude Code, Codex, GitHub Copilot, Warp |
