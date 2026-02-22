#!/bin/bash
set -euo pipefail

# Only run in Claude Code on the web (remote sessions)
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# ── Install gh CLI ────────────────────────────────────────────────────────────
if ! command -v gh &>/dev/null; then
  echo "Installing gh CLI..."
  GH_VERSION=$(curl -sf "https://api.github.com/repos/cli/cli/releases/latest" \
    | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
  curl -fsSL -o /tmp/gh.tar.gz \
    "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz"
  tar -xzf /tmp/gh.tar.gz -C /tmp/
  cp "/tmp/gh_${GH_VERSION}_linux_amd64/bin/gh" /usr/local/bin/gh
  rm -rf /tmp/gh.tar.gz "/tmp/gh_${GH_VERSION}_linux_amd64"
  echo "gh CLI installed: $(gh --version | head -1)"
else
  echo "gh CLI already available: $(gh --version | head -1)"
fi

# ── Configure GitHub token ────────────────────────────────────────────────────
if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo ""
  echo "⚠️  GITHUB_TOKEN is not set."
  echo "   GitHub API calls (e.g. enabling Pages, creating releases) will fail."
  echo ""
  echo "   To fix: create a GitHub Personal Access Token with 'repo' scope at"
  echo "   https://github.com/settings/tokens and add it as GITHUB_TOKEN in"
  echo "   your Claude Code project settings (claude.ai → project → Environment)."
  echo ""
  exit 0
fi

# Persist token for the whole session
echo "export GITHUB_TOKEN=${GITHUB_TOKEN}" >> "${CLAUDE_ENV_FILE}"

# gh CLI automatically uses GITHUB_TOKEN from the environment
echo "gh CLI authenticated as: $(gh api user --jq '.login')"
