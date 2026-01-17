# NSIP Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-Plugin-blueviolet)](https://github.com/anthropics/claude-code)
[![CI](https://github.com/zircote/nsip/actions/workflows/ci.yml/badge.svg)](https://github.com/zircote/nsip/actions/workflows/ci.yml)
[![Version](https://img.shields.io/badge/version-1.4.5-green.svg)](https://github.com/zircote/nsip/releases)

Access NSIP (National Sheep Improvement Program) sheep breeding data through Claude Code with one-command installation.

## Features

- **9 MCP tools** for sheep breeding data access
- **10 slash commands** for quick workflows
- **1 expert agent** (shepherd) for breeding consultation
- **14 automatic hooks** for enhanced functionality
- Automatic package installation via `uvx`
- No manual setup required

## Installation

### From GitHub

```bash
claude plugin install zircote/nsip
```

### Manual Installation

Clone and add to Claude Code:

```bash
git clone https://github.com/zircote/nsip.git
claude --plugin-dir /path/to/nsip
```

## Verify Installation

After installing, verify the MCP tools and commands are working:

```bash
# Test API connectivity
/nsip:test-api

# Get database info (should show last update date)
/nsip:discover

# Verify MCP tools are available
"Use nsip_list_breeds to show available sheep breeds"
```

## Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/nsip:consult` | Expert breeding consultation (uses shepherd agent) | `/nsip:consult I need a terminal sire` |
| `/nsip:discover` | Show database info, breeds, statuses | `/nsip:discover` |
| `/nsip:lookup` | Get animal details by LPN ID | `/nsip:lookup 6####92020###249` |
| `/nsip:profile` | Complete animal profile | `/nsip:profile 6####92020###249` |
| `/nsip:health` | Server performance metrics | `/nsip:health` |
| `/nsip:test-api` | Validate API connectivity | `/nsip:test-api` |
| `/nsip:search` | Search animals with filters | `/nsip:search` |
| `/nsip:traits` | Get trait ranges for breed | `/nsip:traits 486` |
| `/nsip:lineage` | Get pedigree tree | `/nsip:lineage 6####92020###249` |
| `/nsip:progeny` | List offspring | `/nsip:progeny 6####92020###249` |

## Expert Agent

**`/nsip:consult`** invokes the `nsip:shepherd` expert agent, which provides:
- Breeding decision support with NSIP data analysis
- Health diagnosis and treatment recommendations
- Nutrition planning across production stages
- Flock management and culling guidance
- Genetic trait interpretation and selection strategies

## MCP Tools

Ask Claude to use these tools directly:

- `nsip_get_last_update`: Database update date
- `nsip_list_breeds`: Available breed groups
- `nsip_get_statuses`: Animal statuses by breed
- `nsip_get_trait_ranges`: Trait ranges for breed
- `nsip_search_animals`: Search with pagination
- `nsip_get_animal`: Detailed animal information
- `nsip_get_lineage`: Pedigree tree
- `nsip_get_progeny`: Offspring list
- `nsip_search_by_lpn`: Complete animal profile

## Enhanced Features (Hooks)

The plugin includes 14 intelligent hooks that automatically enhance your workflow:

### Hook Categories

**Error Resilience (3 hooks)**
- Auto-retry with exponential backoff
- Fallback to cached data on failures
- Alert tracking for repeated errors

**Context Enhancement (2 hooks)**
- Breed-specific characteristics injection
- Comprehensive trait definitions

**Data Export (2 hooks)**
- Pedigree tree visualizations
- Breeding analysis reports

**Workflow Intelligence (2 hooks)**
- Smart LPN ID detection in prompts
- Comparative analysis suggestions

**Core Operations (5 hooks)**
- API health monitoring
- LPN format validation
- Query logging
- Result caching
- CSV exports

See [hooks/README.md](./hooks/README.md) for detailed documentation.

## Hook Data Locations

**Logs**: `~/.claude-code/nsip-logs/`
**Cache**: `~/.claude-code/nsip-cache/` (60-min TTL)
**Exports**: `~/.claude-code/nsip-exports/`

## File Structure

```
nsip/
├── .claude-plugin/
│   └── plugin.json
├── agents/
│   └── shepherd.md
├── commands/
│   ├── consult.md
│   ├── discover.md
│   ├── health.md
│   ├── lineage.md
│   ├── lookup.md
│   ├── profile.md
│   ├── progeny.md
│   ├── search.md
│   ├── test-api.md
│   └── traits.md
├── hooks/
│   ├── hooks.json
│   ├── README.md
│   └── scripts/
│       ├── api_health_check.py
│       ├── auto_retry.py
│       ├── breed_context_injector.py
│       ├── breeding_report.py
│       ├── comparative_analyzer.py
│       ├── csv_exporter.py
│       ├── error_notifier.py
│       ├── fallback_cache.py
│       ├── lpn_validator.py
│       ├── pedigree_visualizer.py
│       ├── query_logger.py
│       ├── result_cache.py
│       ├── smart_search_detector.py
│       └── trait_dictionary.py
├── tests/
│   ├── unit/
│   ├── integration/
│   └── fixtures/
├── nsip.mcp.json
├── CHANGELOG.md
├── LICENSE
└── README.md
```

## Prerequisites

- Claude Code CLI or VS Code extension
- `uv` package manager (install from https://docs.astral.sh/uv/)
- Internet connection (for first-time package download)

## How It Works

The plugin uses `uvx` to automatically install the `nsip-client` package from GitHub:

1. Claude Code reads `.claude-plugin/plugin.json`
2. Finds the MCP server configuration
3. Runs: `uvx --from git+https://github.com/epicpast/nsip-api-client.git nsip-mcp-server`
4. MCP server starts and connects
5. All tools become available
6. Hooks automatically activate

## Troubleshooting

### MCP Server Doesn't Connect

1. **Check uv installation:**
   ```bash
   uv --version
   uvx --version
   ```

2. **Test the MCP server command manually:**
   ```bash
   uvx --from git+https://github.com/epicpast/nsip-api-client.git nsip-mcp-server
   ```

3. **Re-enable the plugin:**
   ```bash
   claude /plugin disable nsip
   claude /plugin enable nsip
   ```

### API Connection Errors

The NSIP API is public and requires no authentication.

```bash
# Test API directly
curl http://nsipsearch.nsip.org/api/GetLastUpdate
```

## Platform Support

Works identically on:
- Claude Code CLI (terminal)
- Claude Code VS Code extension

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Support

- **MCP Client Repository**: https://github.com/epicpast/nsip-api-client
- **Hook Documentation**: [hooks/README.md](./hooks/README.md)

## License

MIT
