# Architecture Patterns

**Domain:** Claude Code skill pack (ASO Toolkit)
**Researched:** 2026-04-02

## System Overview

The ASO Toolkit is a Claude Code "skill pack" -- a set of markdown files that install into the user's `~/.claude/` directory and provide `/aso:*` slash commands. It has no runtime code, no MCP servers, no API keys. The entire system is markdown prompts that leverage Claude's native tools (WebSearch, Read, Write, Agent/Task).

Claude Code's extension system has three first-class component types that the toolkit must use:

| Component | Location | Loading | Purpose |
|-----------|----------|---------|---------|
| **Skills** (commands) | `~/.claude/skills/<name>/SKILL.md` or `~/.claude/commands/<prefix>/<name>.md` | Description always in context; full content on invocation | User-facing `/slash-commands` with instructions |
| **Agents** (subagents) | `~/.claude/agents/<name>.md` | Description always in context; full prompt on delegation | Specialized workers spawned by skills or Claude |
| **Rules** | `~/.claude/rules/<dir>/<file>.md` | Always loaded into every session | Background constraints, conventions, domain knowledge |

**Critical architecture insight:** Skills and commands are unified in Claude Code 2026. A file at `.claude/commands/aso/audit.md` and one at `.claude/skills/aso-audit/SKILL.md` both create a `/aso:audit` or `/aso-audit` command. The commands/ path is simpler for namespaced packs (the `aso/` subdirectory creates the `aso:` prefix automatically). The skills/ path supports supporting files (templates, scripts). Both accept identical YAML frontmatter.

## Recommended Architecture

```
aso-toolkit/                          (GitHub repo root)
|
|-- commands/
|   `-- aso/
|       |-- audit.md                  /aso:audit  - Store listing audit
|       |-- keywords.md               /aso:keywords - Keyword research
|       |-- optimize.md               /aso:optimize - Metadata optimization
|       `-- help.md                   /aso:help - Command reference
|
|-- agents/
|   `-- aso-analyst.md                Specialized subagent for parallel analysis
|
|-- rules/
|   `-- aso-domain.md                 Always-loaded ASO domain knowledge
|
|-- install.sh                        Copies files to ~/.claude/ and registers
|-- uninstall.sh                      Clean removal
`-- README.md                         Documentation
```

**Why commands/ not skills/:** The project uses a namespaced prefix (`aso:`). Claude Code automatically creates this namespace from subdirectory names in `commands/`. A `commands/aso/audit.md` file becomes `/aso:audit`. With skills, you would need `skills/aso-audit/SKILL.md` per skill -- more directories, no colon namespace, and the flat naming requires longer names to avoid conflicts. Commands is the right fit for a namespaced pack.

**Why a single rules file:** Rules are loaded into every session context. Each rules file consumes context budget. A single `aso-domain.md` file (target: 200-400 lines) provides the essential domain knowledge without bloating context. The detailed, operation-specific knowledge lives in the command files themselves, loaded only when invoked.

## Component Responsibilities

### 1. Rules: `rules/aso-domain.md`

**Responsibility:** Passive domain knowledge that Claude can reference in any conversation, even without invoking an ASO command.

**What belongs here:**
- Platform character limits (iOS: 30 title, 30 subtitle, 100 keywords; Google Play: 50 title, 80 short desc)
- Platform detection logic (how to identify iOS vs Android from URLs/IDs)
- ASO scoring rubric (the criteria and weights used across all commands)
- Industry terminology definitions (impression multiplier, conversion rate, keyword difficulty)
- Output format conventions (report file naming, inline summary format)

**What does NOT belong here:**
- Step-by-step command workflows (those go in command files)
- Web search queries or tool invocation patterns (those go in commands)
- Agent delegation logic (that goes in the command that spawns the agent)

**Size target:** 200-350 lines. This file loads into every session. Every line costs context budget whether or not the user runs ASO commands.

**Loading behavior:** Always loaded. Claude sees this content in every session on any project. This is why brevity matters -- a user working on a React app still pays the context cost.

**Confidence:** HIGH -- verified from official Claude Code docs that rules are always loaded.

### 2. Commands: `commands/aso/*.md`

**Responsibility:** User-facing workflows. Each file is a self-contained prompt that tells Claude exactly what to do when the user invokes the command.

#### `audit.md` -- `/aso:audit`

Full store listing audit. The primary entry point.

**Contains:**
- Frontmatter with `name`, `description`, `argument-hint`, `allowed-tools`
- Platform detection workflow (parse URL/ID, fall back to asking)
- Web search strategy (what to search for, how to extract store data)
- Scoring rubric application (references the rubric from rules/aso-domain.md)
- Output generation (file write + inline summary)
- Agent spawning for competitive analysis (delegates to aso-analyst)

**Size target:** 300-500 lines. Loaded only when invoked.

#### `keywords.md` -- `/aso:keywords`

Keyword research and analysis.

**Contains:**
- Seed keyword extraction from app description
- Web search queries for keyword discovery
- Difficulty/relevance scoring methodology
- Intent grouping (navigational, informational, transactional)
- Platform-specific keyword rules (iOS keyword field vs Google Play indexing)
- Output format

**Size target:** 250-400 lines.

#### `optimize.md` -- `/aso:optimize`

Metadata rewrite with character limit enforcement.

**Contains:**
- Input parsing (existing metadata from audit report or user input)
- Character limit enforcement (hard limits from rules file)
- Rewrite strategy (keyword placement, readability, conversion optimization)
- Before/after comparison output
- Validation checks (does the title still fit? Are keywords duplicated?)

**Size target:** 200-350 lines.

#### `help.md` -- `/aso:help`

Command reference. Displays available commands and usage examples.

**Contains:**
- Static reference content only
- Command list with descriptions
- Usage examples
- Sample output excerpts

**Size target:** 80-120 lines. Minimal -- just a reference card.

**Frontmatter pattern for all commands:**

```yaml
---
name: aso:audit
description: Audit an app store listing with scoring and actionable recommendations
argument-hint: "<app-url-or-id>"
allowed-tools:
  - WebSearch
  - Read
  - Write
  - Agent
---
```

Key frontmatter decisions:
- `disable-model-invocation: true` -- Not needed. Users should be able to say "audit my app" and have Claude auto-invoke.
- `allowed-tools` -- Explicitly list tools. WebSearch is critical (no MCP servers). Agent is needed for spawning aso-analyst.
- `argument-hint` -- Shows expected input in autocomplete.

**Confidence:** HIGH -- frontmatter fields verified against official Claude Code skills documentation.

### 3. Agent: `agents/aso-analyst.md`

**Responsibility:** Parallel analysis worker. Commands spawn this agent for tasks that benefit from isolated context -- primarily competitive analysis via web search.

**Why a subagent, not inline work:**
1. Web search for 3-5 competitors burns significant context. Isolating it in a subagent keeps the main conversation lean.
2. Multiple search queries per competitor (title, subtitle, ratings, description) produce verbose output. The subagent returns only the structured summary.
3. Future extensibility: commands can spawn multiple aso-analyst instances in parallel.

**Contains:**
- Frontmatter: `name`, `description`, `tools`, `model`
- System prompt: Role definition (ASO competitive analyst)
- Input contract: What the spawning command will pass (app category, target keywords, competitor URLs)
- Output contract: Structured markdown summary (competitor table with titles, subtitles, ratings, keyword overlap)
- Search strategy: What queries to run, what to extract
- Guardrails: Do not hallucinate data, mark estimates clearly

**Frontmatter:**

```yaml
---
name: aso-analyst
description: ASO competitive analysis specialist. Researches competitor app listings, extracts metadata, and identifies keyword patterns. Use when analyzing competitors or gathering market data.
tools: WebSearch, Read, Write
model: sonnet
---
```

Key decisions:
- `model: sonnet` -- Good balance of capability and cost. Haiku would be cheaper but competitive analysis requires nuanced web search interpretation.
- `tools` -- No Agent (subagents cannot spawn subagents). No Edit (no need to modify files). WebSearch is the primary tool.
- No `permissionMode` override -- inherits from parent session.

**Size target:** 150-250 lines. Focused system prompt, not a sprawling instruction set.

**Confidence:** HIGH -- subagent architecture verified against official docs. Subagents cannot spawn other subagents (confirmed).

## Data Flow

### Primary Flow: `/aso:audit <url>`

```
User types: /aso:audit https://apps.apple.com/app/myapp/id123456789
                |
                v
    [1] Claude loads audit.md content
        (rules/aso-domain.md already in context)
                |
                v
    [2] Platform detection
        - Parse URL format → iOS detected
        - Extract app ID
                |
                v
    [3] Web search: app store listing
        - WebSearch for app metadata
        - Extract: title, subtitle, description, ratings, screenshots
                |
                v
    [4] Apply scoring rubric (from aso-domain.md rules)
        - Title optimization score
        - Keyword density score
        - Visual asset quality
        - Description effectiveness
        - Ratings/review analysis
                |
                v
    [5] Spawn aso-analyst subagent (competitive analysis)
        - Passes: app category, detected keywords
        - Agent searches for top 3-5 competitors
        - Returns: competitor comparison table
                |
                v
    [6] Generate output
        - Write: ./aso-audit-{app-name}-{date}.md (structured report)
        - Print: inline summary with scores + top 3 recommendations
```

### Secondary Flow: `/aso:keywords <topic-or-url>`

```
User types: /aso:keywords "fitness tracker iOS"
                |
                v
    [1] Claude loads keywords.md content
        (rules/aso-domain.md already in context)
                |
                v
    [2] Input parsing
        - If URL: extract current keywords from listing
        - If topic: use as seed for keyword research
                |
                v
    [3] Keyword discovery via WebSearch
        - Search for category keywords
        - Search for competitor keywords
        - Search for user intent patterns
                |
                v
    [4] Score and group keywords
        - Difficulty estimation (competition level)
        - Relevance scoring (match to app)
        - Intent grouping (navigational/informational/transactional)
                |
                v
    [5] Generate output
        - Write: ./aso-keywords-{topic}-{date}.md
        - Print: top 15 keywords table with scores
```

### Tertiary Flow: `/aso:optimize <existing-report-or-metadata>`

```
User types: /aso:optimize @aso-audit-myapp-2026-04-02.md
                |
                v
    [1] Claude loads optimize.md content
        (rules/aso-domain.md already in context)
                |
                v
    [2] Read existing metadata
        - Parse audit report for current title, subtitle, keywords
        - Or accept raw metadata from user input
                |
                v
    [3] Rewrite with constraints
        - Apply character limits from aso-domain.md rules
        - Optimize keyword placement (front-loading high-value terms)
        - Maintain readability and brand coherence
                |
                v
    [4] Validate
        - Character count check (HARD FAIL if over limit)
        - Keyword deduplication check
        - Before/after comparison
                |
                v
    [5] Generate output
        - Write: ./aso-optimized-{app-name}-{date}.md
        - Print: before/after table with character counts
```

## Integration Points

### Install Script: `install.sh`

The install script is the critical integration point. It must:

1. **Copy files to the right locations:**
   ```bash
   # Commands become /aso:* slash commands
   cp -r commands/aso/ ~/.claude/commands/aso/

   # Agent becomes available for delegation
   cp agents/aso-analyst.md ~/.claude/agents/aso-analyst.md

   # Rules load into every session
   cp rules/aso-domain.md ~/.claude/rules/aso-domain.md
   ```

2. **NOT modify settings.json:**
   Based on research of the actual Claude Code architecture, commands, agents, and rules placed in `~/.claude/` directories are automatically discovered. There is no `commandPaths` or similar field in settings.json. The file-based convention handles discovery.

   This is a major simplification -- the install script only needs to copy files to the right directories. No JSON manipulation required.

3. **Handle idempotency:**
   - Check if files already exist (offer to overwrite or skip)
   - Create directories if they do not exist
   - Print what was installed and where

4. **Uninstall support:**
   An `uninstall.sh` should remove the exact files installed, without touching other commands/agents/rules the user may have.

**Confidence:** HIGH -- verified that `~/.claude/commands/`, `~/.claude/agents/`, and `~/.claude/rules/` are auto-discovered. The ECC plugin, GSD, and official docs all confirm this convention.

### How Components Reference Each Other

```
rules/aso-domain.md
    ^
    | (implicit: always in context, commands can reference its knowledge)
    |
commands/aso/audit.md -----> agents/aso-analyst.md
    |                            ^
    | (spawns via Agent tool)    | (returns structured summary)
    |                            |
commands/aso/optimize.md         |
    |                            |
    | (reads output from audit)  |
    v                            |
commands/aso/keywords.md --------+
    (may also spawn aso-analyst for competitor keyword research)
```

Rules are passive -- they never reference commands or agents. Commands reference the agent by name when spawning it. Commands may reference each other's output files (e.g., optimize reads audit report), but this is through file I/O, not direct invocation.

## Anti-Patterns to Avoid

### Anti-Pattern 1: Fat Rules File
**What:** Putting detailed workflows into the rules file.
**Why bad:** Rules load into every session. A 1000-line rules file burns context on every project, even when the user is not doing ASO work.
**Instead:** Keep rules to essential reference data (limits, rubric weights, terminology). Put workflows in commands (loaded on demand).

### Anti-Pattern 2: Commands That Spawn Commands
**What:** Having `/aso:audit` invoke `/aso:keywords` as a sub-step.
**Why bad:** Claude Code skills cannot invoke other skills programmatically. A skill invocation is a user-facing action, not a function call.
**Instead:** Extract shared logic into the rules file or duplicate essential steps across commands. If a workflow needs chaining, document it: "Run /aso:audit first, then /aso:optimize on the output."

### Anti-Pattern 3: Agent as Command
**What:** Making the aso-analyst agent user-invocable.
**Why bad:** The agent has a narrow system prompt designed for competitive analysis subtasks. Users invoking it directly would get poor results -- it expects structured input from a command.
**Instead:** Keep the agent as a subagent only. Commands are the user-facing interface; the agent is an implementation detail.

### Anti-Pattern 4: MCP Server for Web Data
**What:** Building an MCP server to scrape app store data.
**Why bad:** Violates the zero-infrastructure constraint. Adds Python/Node dependency. Claude's native WebSearch can fetch store listing data.
**Instead:** Use WebSearch in commands and the agent. Accept that data is best-effort (WebSearch results, not direct API).

### Anti-Pattern 5: Modifying settings.json in install.sh
**What:** Using `jq` or similar to inject configuration into the user's `~/.claude/settings.json`.
**Why bad:** Risk of corrupting user config. Race conditions with other tools. Not necessary -- file-based discovery handles registration.
**Instead:** Copy files to conventional directories. That is the entire install process.

## Patterns to Follow

### Pattern 1: Command Delegates to Subagent for Expensive Work
**What:** The audit command handles the main workflow inline but spawns aso-analyst for competitive analysis.
**When:** Any operation that requires multiple web searches or produces verbose intermediate output.
**Example:**
```markdown
## Step 5: Competitive Analysis

Spawn the aso-analyst subagent to research competitors:
- Pass the app's category and top 5 keywords
- The agent will search for top competitors and return a comparison table
- Include the agent's output in the Competitive Landscape section of the report
```

### Pattern 2: Rules as Shared Constants
**What:** Character limits, scoring weights, and platform detection regex live in the rules file. Commands reference them by concept ("apply the scoring rubric"), not by copying the data.
**When:** Any data needed by multiple commands.
**Why:** Single source of truth. Update limits in one place.

### Pattern 3: File-Based Output with Inline Summary
**What:** Every command writes a detailed .md report AND prints a condensed summary inline.
**When:** Always. Both outputs serve different needs (reference vs. quick review).
**Why:** Users want to see results immediately (inline) but also need a persistent artifact (file).

### Pattern 4: Explicit Platform Detection Before Analysis
**What:** Every command that analyzes an app starts by detecting the platform (iOS/Android) from the input URL or ID format before doing any work.
**When:** Any command that receives an app URL or ID as input.
**Why:** Platform determines character limits, keyword handling, and search strategies. Getting it wrong cascades through the entire analysis.

## Build Order

Components have dependencies that determine the order they should be built:

```
Phase 1: rules/aso-domain.md
         (Foundation -- character limits, rubric, terminology)
         (No dependencies. Other components reference this.)
              |
              v
Phase 2: commands/aso/audit.md + agents/aso-analyst.md
         (Core workflow. Agent is spawned by audit.)
         (Depends on: rules file for domain knowledge)
         (Build together -- audit needs the agent for competitive analysis)
              |
              v
Phase 3: commands/aso/keywords.md
         (Keyword research. Independent workflow but may use agent.)
         (Depends on: rules file. Optionally uses agent.)
              |
              v
Phase 4: commands/aso/optimize.md
         (Metadata rewrite. Reads audit output.)
         (Depends on: rules file. Benefits from audit output format being stable.)
              |
              v
Phase 5: commands/aso/help.md + install.sh + uninstall.sh + README.md
         (Distribution. Needs all commands to exist first.)
         (Depends on: all commands being finalized for accurate help text.)
```

**Rationale:** The rules file is the foundation -- it defines the shared vocabulary and constraints. The audit command is the highest-value feature and the most complex (it spawns the agent). Keywords and optimize are independent but simpler. Help and install are purely distribution concerns.

## Scalability Considerations

| Concern | At 1 command | At 5 commands | At 15+ commands |
|---------|-------------|---------------|-----------------|
| Context budget | Negligible. Rules + command descriptions fit easily. | Manageable. ~1500 chars for descriptions. | Watch the description budget. Consider `disable-model-invocation: true` on rarely-used commands. |
| Namespace collisions | None. `aso:` prefix is unique. | None. All under `aso:` prefix. | Consider sub-namespaces: `aso:research:*`, `aso:optimize:*`. |
| Agent complexity | Single agent, clear purpose. | May need 2-3 specialized agents. | Consider agent-per-domain (keywords agent, visual agent, etc.). |
| Install script | Simple cp commands. | Still simple. | Consider a manifest file listing all files to copy. |
| Rules file size | Under 200 lines. | 200-400 lines. | Split into `rules/aso/domain.md` and `rules/aso/platforms.md`. Watch total context cost. |

## Sources

- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills) -- Official docs on skill structure, frontmatter, discovery, invocation control (HIGH confidence)
- [Claude Code Settings Documentation](https://code.claude.com/docs/en/settings) -- Settings scopes, file-based discovery conventions (HIGH confidence)
- [Claude Code Subagents Documentation](https://code.claude.com/docs/en/sub-agents) -- Agent definition, frontmatter fields, tool restrictions, delegation patterns (HIGH confidence)
- Direct inspection of `~/.claude/commands/gsd/` -- GSD slash command structure, frontmatter patterns, `@` reference includes (HIGH confidence)
- Direct inspection of `~/.claude/agents/` -- Agent file format, model selection, tool restrictions (HIGH confidence)
- Direct inspection of `~/.claude/rules/` -- Rules directory structure, per-language subdirectories (HIGH confidence)
- Direct inspection of `~/.claude/settings.json` -- Hooks registration, no commandPaths field present (HIGH confidence)
- [ECC Plugin Schema Notes](file://~/.claude/PLUGIN_SCHEMA_NOTES.md) -- Plugin manifest constraints, path resolution rules (HIGH confidence)
