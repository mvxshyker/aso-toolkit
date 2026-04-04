#!/usr/bin/env bash
# ASO Toolkit installer
# Copies skills and agents to ~/.claude/ so slash commands appear naturally.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_HOME="${HOME}/.claude"
ASO_VAULT="${ASO_VAULT:-}"

echo "Installing ASO Toolkit..."

if [ -n "$ASO_VAULT" ]; then
    if [ ! -d "$ASO_VAULT" ]; then
        echo "  Warning: ASO_VAULT is set but directory not found at $ASO_VAULT"
        echo "  Skills will install without vault path resolution."
        ASO_VAULT=""
    else
        echo "  Vault path: $ASO_VAULT"
    fi
else
    echo "  No vault configured — skills will use general ASO knowledge."
    echo "  To connect a knowledge base later: export ASO_VAULT=/path/to/vault && ./install.sh"
fi

# Install skills
if [ -d "$SCRIPT_DIR/skills" ]; then
    for skill_dir in "$SCRIPT_DIR/skills"/*/; do
        skill_name="$(basename "$skill_dir")"
        target="$CLAUDE_HOME/skills/$skill_name"
        mkdir -p "$target"
        for f in "$skill_dir"*; do
            if [[ "$f" == *.md ]] && [ -n "$ASO_VAULT" ]; then
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
