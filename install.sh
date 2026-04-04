#!/usr/bin/env bash
# ASO Toolkit installer
# Usage: curl -fsSL https://raw.githubusercontent.com/mvxshyker/aso-toolkit/main/install.sh | bash
# Or:    ./install.sh (if cloned locally)

set -euo pipefail

REPO="mvxshyker/aso-toolkit"
BRANCH="main"
CLAUDE_HOME="${HOME}/.claude"
ASO_VAULT="${ASO_VAULT:-}"
TMPDIR_INSTALL=""

# Determine source: local clone or remote download
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" 2>/dev/null || echo ".")" && pwd)"
if [ -d "$SCRIPT_DIR/skills" ] && [ -d "$SCRIPT_DIR/agents" ]; then
    SOURCE="$SCRIPT_DIR"
else
    TMPDIR_INSTALL="$(mktemp -d)"
    echo "Downloading ASO Toolkit..."
    curl -fsSL "https://github.com/$REPO/archive/$BRANCH.tar.gz" | tar xz -C "$TMPDIR_INSTALL" --strip-components=1
    SOURCE="$TMPDIR_INSTALL"
fi

echo "Installing ASO Toolkit..."

if [ -n "$ASO_VAULT" ]; then
    if [ ! -d "$ASO_VAULT" ]; then
        echo "  Warning: ASO_VAULT is set but directory not found at $ASO_VAULT"
        echo "  Skills will install without vault path resolution."
        ASO_VAULT=""
    else
        echo "  Vault: $ASO_VAULT"
    fi
fi

# Install skills
for skill_dir in "$SOURCE/skills"/*/; do
    [ -d "$skill_dir" ] || continue
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

# Install agents
mkdir -p "$CLAUDE_HOME/agents"
for agent_file in "$SOURCE/agents"/*.md; do
    [ -f "$agent_file" ] || continue
    cp "$agent_file" "$CLAUDE_HOME/agents/"
    echo "  ✓ Agent: $(basename "$agent_file" .md)"
done

# Create output directory for approved copy
OUTPUT_DIR="${HOME}/.aso-toolkit/output"
mkdir -p "$OUTPUT_DIR"

# Cleanup temp download
[ -n "$TMPDIR_INSTALL" ] && rm -rf "$TMPDIR_INSTALL"

echo ""
echo "Done. Restart Claude Code to pick up new commands."
echo ""
echo "Commands:"
for skill_dir in "$CLAUDE_HOME/skills"/aso-*/; do
    [ -d "$skill_dir" ] || continue
    name="$(basename "$skill_dir" | sed 's/-/:/g')"
    echo "  /$name"
done
echo ""
echo "Locations:"
echo "  Skills:  $CLAUDE_HOME/skills/aso-*/"
echo "  Agents:  $CLAUDE_HOME/agents/aso-*"
echo "  Output:  $OUTPUT_DIR/"
[ -n "$ASO_VAULT" ] && echo "  Vault:   $ASO_VAULT"
