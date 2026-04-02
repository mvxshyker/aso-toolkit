#!/usr/bin/env bash
# ASO Toolkit installer
# Copies skills and agents to ~/.claude/ so slash commands appear naturally.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_HOME="${HOME}/.claude"

echo "Installing ASO Toolkit..."

# Install skills
if [ -d "$SCRIPT_DIR/skills" ]; then
    for skill_dir in "$SCRIPT_DIR/skills"/*/; do
        skill_name="$(basename "$skill_dir")"
        target="$CLAUDE_HOME/skills/$skill_name"
        mkdir -p "$target"
        cp -R "$skill_dir"* "$target/"
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
