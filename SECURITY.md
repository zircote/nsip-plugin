# Security Policy

## Overview

The NSIP Plugin is a Claude Code plugin that provides access to the National Sheep Improvement Program (NSIP) public API. This document outlines security considerations and vulnerability reporting procedures.

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.4.x   | :white_check_mark: |
| < 1.4   | :x:                |

## Security Model

### API Access

- **Public API**: The NSIP API is publicly accessible and does not require authentication
- **Read-only**: All operations are read-only queries against the NSIP database
- **No credentials stored**: This plugin does not store or transmit any credentials

### Plugin Architecture

- **Hooks**: Python scripts using only the standard library (no third-party dependencies)
- **Fail-safe design**: All hooks exit with code 0 to prevent blocking Claude Code operations
- **Input validation**: LPN IDs are validated before API calls (alphanumeric, 5-50 chars)
- **No persistent storage**: Cache files are stored locally in `~/.claude/nsip/` with read/write permissions for the user only

### Data Handling

- **Local caching**: API responses may be cached locally for performance (60-minute TTL)
- **No PII**: NSIP data contains sheep breeding records, not personal information
- **Log files**: Query logs stored in `~/.claude/nsip/logs/` contain only API queries, not sensitive data

## Reporting a Vulnerability

If you discover a security vulnerability in this plugin, please report it responsibly:

1. **Do not** open a public issue for security vulnerabilities
2. **Email**: Contact the maintainers privately at [security@zircote.com](mailto:security@zircote.com)
3. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial assessment**: Within 7 days
- **Resolution target**:
  - Critical: 7 days
  - High: 30 days
  - Medium: 90 days
  - Low: Next release

## Security Best Practices for Users

1. **Keep updated**: Use the latest version of the plugin
2. **Review hooks**: Hook scripts are plain Python; review them if concerned
3. **Check permissions**: Ensure `~/.claude/nsip/` has appropriate permissions (700)
4. **Network security**: API calls are made over HTTPS

## Scope

This security policy covers:

- The NSIP Claude Code plugin repository
- Hook scripts in `hooks/scripts/`
- Plugin configuration files

This policy does **not** cover:

- The upstream NSIP API (managed by NSIP)
- The `nsip-api-client` MCP server package (separate repository)
- Claude Code itself (managed by Anthropic)

## External Dependencies

| Dependency | Source | Security Notes |
|------------|--------|----------------|
| nsip-api-client | GitHub (epicpast/nsip-api-client) | External MCP server; installed via uvx |
| Python stdlib | System Python | No third-party packages in hooks |

## Changelog

- **2026-01-19**: Initial security policy created
