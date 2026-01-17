# Copilot Instructions

You are working in the NSIP plugin repository for Claude Code.

## Project Overview

This is a Claude Code plugin for accessing NSIP (National Sheep Improvement Program) sheep breeding data through MCP tools and slash commands.

## Key Components

- **Commands**: 10 slash commands for NSIP data access
- **Agents**: 1 expert agent (shepherd) for breeding consultation
- **Hooks**: 14 Python hooks for error resilience, caching, and exports
- **Tests**: Unit and integration tests for hook functionality

## Plugin Structure

```
.claude-plugin/plugin.json  # Plugin manifest
commands/                   # 10 NSIP commands
agents/                     # Shepherd expert agent
hooks/                      # 14 Python hook scripts
tests/                      # Unit and integration tests
nsip.mcp.json              # MCP server configuration
```

## Development Guidelines

1. Follow Claude Code plugin standards
2. Keep changes focused and reviewable
3. Update CHANGELOG.md for user-facing changes
4. Test hooks locally before committing

## Testing

```bash
# Run all tests
python -m pytest tests/ -v

# Run specific test file
python -m pytest tests/unit/test_session_start.py -v
```

## Hook Development

Hooks are Python scripts in `hooks/scripts/`. Each hook:
- Receives JSON input via stdin
- Outputs JSON result to stdout
- Logs to `~/.claude-code/nsip-logs/`
- Caches to `~/.claude-code/nsip-cache/`

## Security

- Never hardcode API keys or tokens
- The NSIP API is public and requires no authentication
- Prefer env vars for any future authentication needs
