---
title: "Claude Code Plugin Architecture"
description: "Foundational architecture decisions for the NSIP Claude Code plugin"
type: adr
category: architecture
tags:
  - plugin
  - claude-code
  - mcp
  - hooks
status: accepted
created: 2025-01-19
updated: 2025-01-19
author: zircote
project: nsip-claude-plugin
technologies:
  - claude-code
  - mcp
  - python
audience:
  - developers
  - maintainers
related: []
---

# ADR-001: Claude Code Plugin Architecture

## Status

Accepted

## Context

### Background and Problem Statement

The NSIP (National Sheep Improvement Program) provides a REST API for accessing sheep breeding data, including animal records, genetic evaluations (EBVs), lineage information, and breed statistics. Users of Claude Code need a way to interact with this API naturally through conversation while receiving contextual assistance for breeding decisions.

The challenge is to create a Claude Code plugin that:
1. Provides seamless access to NSIP API functionality
2. Enhances user prompts with domain-specific context
3. Validates inputs and handles errors gracefully
4. Remains maintainable with minimal complexity

### Current Limitations

1. **No existing integration**: Claude Code has no built-in knowledge of NSIP data structures or API endpoints
2. **Domain complexity**: Sheep breeding involves specialized terminology (EBVs, LPN IDs, breed codes) that requires context
3. **API reliability**: External API calls may fail, requiring graceful degradation
4. **User experience**: Raw API responses need interpretation for breeding decisions

## Decision Drivers

### Primary Decision Drivers

1. **Reliability**: Plugin must never block or crash Claude Code operations
2. **Maintainability**: Architecture must be simple enough for long-term maintenance without dedicated team
3. **User Experience**: Interactions should feel natural and provide actionable insights

### Secondary Decision Drivers

1. **Portability**: Plugin should work across different environments without complex setup
2. **Extensibility**: Architecture should allow adding new capabilities without major refactoring
3. **Testability**: Components should be independently testable

## Considered Options

### Option 1: Declarative Plugin with External MCP Server

**Description**: Use Claude Code's declarative plugin system (JSON + Markdown) for configuration, commands, and agents. Delegate all API communication to an external MCP server. Use Python hooks only for input validation, context injection, and logging.

**Technical Characteristics**:
- Plugin manifest (`plugin.json`) defines metadata and capabilities
- Markdown files define commands, agents, and skills
- External MCP server handles all NSIP API communication
- Python hooks for PreToolUse/PostToolUse/UserPromptSubmit events
- Hooks use Python stdlib only (no external dependencies)

**Advantages**:
- Clear separation of concerns (plugin logic vs API access)
- Hooks are simple and focused (validation, logging, context)
- MCP server can be updated independently
- No dependency management in plugin
- Leverages Claude Code's built-in capabilities

**Disadvantages**:
- Requires external MCP server to be running
- Two components to maintain (plugin + MCP server)
- Limited to hook events provided by Claude Code

**Risk Assessment**:
- **Technical Risk**: Low. Uses established Claude Code patterns.
- **Schedule Risk**: Low. Declarative approach reduces development time.
- **Ecosystem Risk**: Low. MCP is a stable, supported protocol.

### Option 2: Monolithic Plugin with Embedded API Client

**Description**: Implement all functionality within the plugin, including direct API calls from Python hooks.

**Technical Characteristics**:
- Hooks make direct HTTP calls to NSIP API
- All logic contained within plugin directory
- Requires `requests` or similar HTTP library

**Advantages**:
- Single component to deploy
- No external dependencies beyond the plugin

**Disadvantages**:
- Violates fail-safe principle (API calls in hooks can block/timeout)
- Requires dependency management (external libraries)
- Mixes concerns (validation + API access + response handling)
- Harder to test individual components
- Environment-specific issues (SSL, proxies, timeouts)

**Disqualifying Factor**: Hooks that make network calls violate the fail-safe principle. A slow or failed API call could degrade Claude Code's responsiveness.

**Risk Assessment**:
- **Technical Risk**: High. Network calls in hooks are fragile.
- **Schedule Risk**: Medium. Debugging network issues takes time.
- **Ecosystem Risk**: Medium. Dependency on external HTTP libraries.

### Option 3: Pure MCP Without Plugin Hooks

**Description**: Use only MCP server for all functionality, with no plugin hooks.

**Technical Characteristics**:
- MCP server provides all tools
- No PreToolUse/PostToolUse validation
- No UserPromptSubmit context injection

**Advantages**:
- Simplest architecture
- Single component

**Disadvantages**:
- No input validation before API calls
- No context injection for user prompts
- No logging of tool usage
- Misses Claude Code plugin capabilities (commands, agents, skills)

**Risk Assessment**:
- **Technical Risk**: Low. MCP is straightforward.
- **Schedule Risk**: Low. Less to implement.
- **Ecosystem Risk**: Low. Standard MCP pattern.

## Decision

Adopt **Option 1: Declarative Plugin with External MCP Server**.

The implementation will use:
- **Declarative configuration** for plugin structure (JSON manifests, Markdown content)
- **External MCP server** for all NSIP API communication
- **Python hooks** for validation, context injection, and logging only
- **Stdlib-only hooks** to ensure portability and fail-safe behavior

Hook design principles:
1. Always exit 0 (never block Claude)
2. Use `try/except` around all operations
3. No network calls
4. No external dependencies
5. Log errors but continue execution

## Consequences

### Positive

1. **Fail-safe operation**: Hooks cannot block Claude Code even if they encounter errors
2. **Clean separation**: API complexity isolated in MCP server, plugin remains simple
3. **Easy testing**: Hooks testable with mock data, MCP server testable independently
4. **Future-proof**: Can add new hooks without affecting MCP server, and vice versa

### Negative

1. **Deployment complexity**: Two components must be running (plugin + MCP server)
2. **Coordination overhead**: Changes to API may require updates in both components

### Neutral

1. **Learning curve**: Developers must understand both Claude Code plugins and MCP protocol

## Decision Outcome

This architecture achieves its primary objectives:
- **Reliability**: Hooks are fail-safe by design
- **Maintainability**: Declarative-first approach minimizes code complexity
- **User Experience**: Context injection and validation improve interactions

Mitigations:
- Document MCP server setup clearly for deployment complexity
- Use shared type definitions to reduce coordination overhead

## Related Decisions

None (first ADR)

## Links

- [Claude Code Plugin Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [NSIP API Documentation](https://nsip.org/resources)

## More Information

- **Date:** 2025-01-19
- **Source:** Initial plugin architecture design
- **Related ADRs:** None

## Audit

### 2025-01-19

**Status:** Compliant

**Findings:**

| Finding | Files | Lines | Assessment |
|---------|-------|-------|------------|
| Plugin manifest declares external MCP | `nsip.mcp.json` | L1-L20 | compliant |
| Hooks use stdlib only | `hooks/scripts/*.py` | all | compliant |
| All hooks exit 0 on error | `hooks/scripts/*.py` | all | compliant |
| Declarative commands/agents | `commands/*.md`, `agents/*.md` | all | compliant |

**Summary:** Architecture implementation matches this ADR. All hooks follow fail-safe patterns.

**Action Required:** None
