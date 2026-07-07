# Project Context for Codex Agent

## Environment
- OS: macOS (Darwin, arm64)
- Shell: zsh 5.9
- Python: 3.8.20 (pyenv)
- Node.js: 25.8.1

## Active Projects

### vorim-project (`~/vorim-project`)
Node.js project using `@vorim/a2a` — Vorim AI identity and trust layer for the Google A2A Protocol.
- Production branch deployed to GitHub: `phillipthomaschima-collab/vorim-project`
- 0 npm vulnerabilities
- Requires `VORIM_API_KEY` env variable for live API calls

### api-sec-tester (`~/Documents/My Work/api-sec-tester`)
Python CLI tool for running security checks against API endpoints.
- Checks: auth, cors, headers, methods, injection, rate_limit, info_disclosure
- Run: `python main.py <url> --output report.json`
- Dependencies: requests, colorama, urllib3

### security_test_tool (`~/security_test_tool`)
Scaffolded project with frontend (App.js) and backend (main.py) — currently empty placeholder files.

## Key Environment Variables
- `VORIM_API_KEY` — required for vorim-project API calls
- `OPENAI_API_KEY` — required for Codex CLI

## Conventions
- Git default branch: `main`
- Python managed via pyenv (version 3.8.20)
- Node packages installed globally via npm
