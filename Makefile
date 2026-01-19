# NSIP Claude Code Plugin - Build System
# =======================================
# Targets for validation, linting, testing, and CI gates

.PHONY: validate lint lint-strict format format-check test ci clean help

# Default target
.DEFAULT_GOAL := help

# -----------------------------------------------------------------------------
# Validation
# -----------------------------------------------------------------------------

validate: ## Validate JSON configuration files
	@echo "==> Validating JSON configs..."
	@python3 -m json.tool .claude-plugin/plugin.json > /dev/null && echo "  ✓ plugin.json"
	@python3 -m json.tool hooks/hooks.json > /dev/null && echo "  ✓ hooks.json"
	@python3 -m json.tool nsip.mcp.json > /dev/null && echo "  ✓ nsip.mcp.json"
	@echo "✓ All JSON valid"

# -----------------------------------------------------------------------------
# Linting (uses uvx for portability - no global install required)
# -----------------------------------------------------------------------------

lint: ## Lint Python code with ruff (warnings allowed)
	@echo "==> Linting Python..."
	@uvx ruff check hooks/scripts/ tests/

lint-strict: ## Lint Python code with ruff (warnings as errors)
	@echo "==> Linting Python (strict)..."
	@uvx ruff check hooks/scripts/ tests/ --exit-non-zero-on-fix

# -----------------------------------------------------------------------------
# Formatting (uses uvx for portability)
# -----------------------------------------------------------------------------

format: ## Format Python code with ruff
	@echo "==> Formatting Python..."
	@uvx ruff format hooks/scripts/ tests/
	@uvx ruff check --fix hooks/scripts/ tests/
	@echo "✓ Formatting complete"

format-check: ## Check Python formatting without changes
	@echo "==> Checking format..."
	@uvx ruff format --check hooks/scripts/ tests/

# -----------------------------------------------------------------------------
# Testing (uses uvx for portability)
# -----------------------------------------------------------------------------

test: ## Run pytest test suite
	@echo "==> Running tests..."
	@uvx pytest tests/ -v

test-unit: ## Run unit tests only
	@echo "==> Running unit tests..."
	@uvx pytest tests/unit/ -v

test-integration: ## Run integration tests only
	@echo "==> Running integration tests..."
	@uvx pytest tests/integration/ -v

# -----------------------------------------------------------------------------
# CI Gate
# -----------------------------------------------------------------------------

ci: validate format-check lint-strict test ## Run all CI checks locally
	@echo ""
	@echo "============================================"
	@echo "✓ All CI checks passed"
	@echo "============================================"

# -----------------------------------------------------------------------------
# Utilities
# -----------------------------------------------------------------------------

clean: ## Remove cache and temporary files
	@echo "==> Cleaning..."
	@rm -rf __pycache__ .pytest_cache .ruff_cache
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@echo "✓ Clean complete"

# -----------------------------------------------------------------------------
# Help
# -----------------------------------------------------------------------------

help: ## Show this help message
	@echo "NSIP Claude Code Plugin"
	@echo "======================="
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Usage: make <target>"
