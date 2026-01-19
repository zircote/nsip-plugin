# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) for the NSIP Claude Code Plugin.

## What is an ADR?

An Architectural Decision Record (ADR) captures an important architectural decision made along with its context and consequences. ADRs help teams understand why decisions were made and provide a historical record of architectural evolution.

## ADR Index

| ID | Title | Status | Date |
|----|-------|--------|------|
| [ADR-001](adr-001-plugin-architecture.md) | Claude Code Plugin Architecture | Accepted | 2025-01-19 |

## Status Legend

| Status | Description |
|--------|-------------|
| proposed | Decision is under consideration |
| accepted | Decision has been approved and is active |
| deprecated | Decision is no longer recommended |
| superseded | Decision has been replaced by another ADR |
| rejected | Decision was considered but not adopted |

## Creating New ADRs

Use the `/adr:adr-new` command to create a new ADR:

```
/adr:adr-new "Title of the decision"
```

## ADR Summary

### ADR-001: Claude Code Plugin Architecture
Establishes the foundational architecture for the NSIP Claude Code plugin, choosing a declarative-first approach with external MCP server integration and fail-safe Python hooks.

---

## Guidelines

- Write ADRs for significant architectural decisions
- Keep decisions focused and atomic
- Document alternatives considered
- Update status when decisions change
