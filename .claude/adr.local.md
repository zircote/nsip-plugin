---
adr_paths:
  - docs/decisions

default_format: structured-madr

numbering:
  pattern: "###"
  start_from: 1

statuses:
  workflow:
    - proposed
    - accepted
    - deprecated
    - superseded
  allow_rejected: true

git:
  enabled: true
  auto_commit: false
  commit_template: "docs(adr): {action} ADR-{id} {title}"
---

# NSIP Claude Code Plugin ADR Context

Architecture Decision Records for the NSIP Claude Code Plugin.

## Decision Process

- ADRs are proposed via pull request
- Team review recommended before acceptance
- Use `/adr:adr-new` to create new ADRs
- Use `/adr:adr-update` to change status or content

## Project Context

This plugin provides Claude Code integration with the NSIP (National Sheep Improvement Program) API for sheep breeding data analysis. Key architectural considerations:

- **Declarative-first**: JSON/Markdown configuration over code
- **Fail-safe hooks**: Python hooks must never block Claude operations
- **External MCP**: API access delegated to external MCP server
- **Zero dependencies**: Hooks use Python stdlib only
