# CLAUDE.md

Project-specific instructions for Claude Code when working in this repository.

## Project Overview

This is the **NSIP Plugin** - a Claude Code plugin for accessing NSIP (National Sheep Improvement Program) sheep breeding data through MCP tools and slash commands.

## Technology Stack

| Component | Technology |
|-----------|------------|
| Plugin type | Claude Code Plugin (declarative) |
| Configuration | JSON (plugin.json, hooks.json) |
| Commands/Agents | Markdown with YAML frontmatter |
| Hooks | Python 3.8+ (stdlib only) |
| MCP Server | External package (nsip-api-client) |
| Testing | pytest, pytest-asyncio |
| Linting | ruff |

## Project Structure

```
.claude-plugin/plugin.json  # Plugin manifest
commands/                   # 10 slash commands (Markdown)
agents/                     # 1 expert agent (Markdown)
hooks/
  hooks.json               # Hook configuration
  scripts/                 # 14 Python hook scripts
  README.md                # Hook documentation
tests/
  unit/                    # Unit tests
  integration/             # Integration tests
  fixtures/                # Test data
docs/adrs/                 # Architecture Decision Records
```

## Build System

Use `make` for all development tasks:

```bash
make help          # Show available targets
make validate      # Validate JSON configs
make lint          # Lint Python with ruff
make format        # Format Python with ruff
make test          # Run pytest
make ci            # Run all CI checks locally
```

## Development Guidelines

### Hooks

1. **Stdlib only**: Hooks must use only Python standard library
2. **Fail-safe**: Hooks must exit 0 regardless of errors (never crash Claude Code)
3. **JSON I/O**: Receive JSON via stdin, output JSON to stdout
4. **Logging**: Log to `~/.claude/nsip/logs/`
5. **Caching**: Cache to `~/.claude/nsip/cache/`

### Commands and Agents

1. Use YAML frontmatter for metadata
2. Follow existing command patterns
3. Document `allowed_tools` restrictions

### Testing

1. All new hooks require tests in `tests/unit/`
2. Complex workflows need integration tests
3. Target 80%+ coverage

## Code Quality

### Linting Rules (ruff.toml)

- Line length: 100 characters
- Target: Python 3.8+
- Enabled: E, W, F, I, B, C4, UP, SIM, PIE, RUF

### Formatting

Run `make format` before committing Python changes.

## Version Management

Version is managed via `.bumpversion.toml`. To release:

```bash
# Patch release (1.4.5 -> 1.4.6)
bump2version patch

# Minor release (1.4.5 -> 1.5.0)
bump2version minor
```

## CI/CD Pipeline

CI runs on every push and PR to main:

1. **Validate**: JSON syntax and structure
2. **Lint**: ruff format check + lint
3. **Test**: pytest suite

All jobs must pass before merge.

## Security Notes

- NSIP API is public (no authentication)
- No credentials stored in this repository
- Hooks handle untrusted input (validate before use)
- See SECURITY.md for vulnerability reporting

## ADRs

Architecture decisions are documented in `docs/adrs/`. Review before making architectural changes.

## External Dependencies

| Dependency | Location | Notes |
|------------|----------|-------|
| nsip-api-client | GitHub (epicpast/nsip-api-client) | MCP server, installed via uvx |
| pytest | PyPI | Test framework (dev only) |
| ruff | PyPI | Linter/formatter (dev only) |
