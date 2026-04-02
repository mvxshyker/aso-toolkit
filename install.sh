#!/usr/bin/env bash
# ASO Toolkit installer
# Copies skills and agents to ~/.claude/ so slash commands appear naturally.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_HOME="${HOME}/.claude"
if [ -z "${ASO_VAULT:-}" ]; then
    echo "Error: ASO_VAULT is not set."
    echo ""
    echo "  export ASO_VAULT=\"/path/to/your/obsidian/vault/ASO\""
    echo "  ./install.sh"
    echo ""
    exit 1
fi

echo "Installing ASO Toolkit..."
echo "  Vault path: $ASO_VAULT"

if [ ! -d "$ASO_VAULT" ]; then
    echo "  ⚠ Vault not found at $ASO_VAULT"
    echo "  Set ASO_VAULT env var to your vault path and re-run."
    exit 1
fi

# Install skills (resolve $ASO_VAULT in SKILL.md)
if [ -d "$SCRIPT_DIR/skills" ]; then
    for skill_dir in "$SCRIPT_DIR/skills"/*/; do
        skill_name="$(basename "$skill_dir")"
        target="$CLAUDE_HOME/skills/$skill_name"
        mkdir -p "$target"
        for f in "$skill_dir"*; do
            if [[ "$f" == *.md ]]; then
                sed "s|\$ASO_VAULT|$ASO_VAULT|g" "$f" > "$target/$(basename "$f")"
            else
                cp -R "$f" "$target/"
            fi
        done
        echo "  ✓ Skill: $skill_name"
    done
fi

# Install agents
if [ -d "$SCRIPT_DIR/agents" ]; then
    mkdir -p "$CLAUDE_HOME/agents"
    for agent_file in "$SCRIPT_DIR/agents"/*.md; do
        [ -f "$agent_file" ] || continue
        cp "$agent_file" "$CLAUDE_HOME/agents/"
        echo "  ✓ Agent: $(basename "$agent_file")"
    done
fi

echo ""
echo "Done. Available commands:"
for skill_dir in "$CLAUDE_HOME/skills"/aso-*/; do
    [ -d "$skill_dir" ] || continue
    name="$(basename "$skill_dir" | sed 's/-/:/g')"
    echo "  /$name"
done
echo ""
echo "Restart Claude Code to pick up new commands."
