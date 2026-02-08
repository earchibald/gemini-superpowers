#!/usr/bin/env bash
set -e

# ==============================================================================
# Acknowledgements:
# - Inspired by and based on the original Superpowers framework by Jesse Vincent (@obra).
# ==============================================================================
# 🦸 GEMINI CLI SUPERPOWERS INSTALLER
# ==============================================================================
# "Radically Simple" Adapter for Google Gemini CLI
#
# 1. Clones obra/superpowers to ~/.cache/superpowers
# 2. Generates native .toml slash commands in ~/.gemini/commands/
# 3. Injects the "Loop of Autonomy" protocol into ~/.gemini/GEMINI.md
# ==============================================================================

## Documentation

For a comprehensive overview, detailed command references, and insights into the Gemini-specific cost model, please refer to our [full documentation](./docs/README.md).

You can also find a quick reference for all available slash commands in the [Cheatsheet](./docs/CHEATSHEET.md).

## Release 0.1.0

This marks the initial public release of Gemini Superpowers, bringing the powerful Superpowers framework to Google Gemini CLI. We aim to empower developers with an efficient, structured, and autonomous agent workflow.

# --- Configuration ---
REPO_URL="https://github.com/obra/superpowers"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/superpowers"
GEMINI_ROOT="$HOME/.gemini"
COMMANDS_DIR="$GEMINI_ROOT/commands"
CONTEXT_FILE="$GEMINI_ROOT/GEMINI.md"

# --- Mappings: SkillDir:CommandName:Description ---
SKILLS=(
    "writing-plans:plan:Create a detailed implementation plan"
    "executing-plans:execute:Execute an implementation plan task-by-task"
    "brainstorming:brainstorm:Refine ideas through Socratic dialogue"
    "test-driven-development:tdd:Implement code using strict Red-Green-Refactor"
    "systematic-debugging:investigate:Perform systematic root-cause analysis"
    "verification-before-completion:verify:Verify fixes before signing off"
    "using-git-worktrees:worktree:Create isolated git worktree for features"
    "finishing-a-development-branch:finish:Merge, PR, or discard current branch"
    "requesting-code-review:review:Request a self-correction code review"
    "receiving-code-review:receive:Respond to code review feedback"
    "subagent-driven-development:subagent:Dispatch subagents for rapid development"
    "dispatching-parallel-agents:dispatch:Run parallel subagent workflows"
    "writing-skills:newskill:Create a new Superpowers skill"
    "using-superpowers:superpowers:Learn about available Superpowers"
)

echo "🦸 Gemini CLI Superpowers Installer"
echo "==================================="

# 1. Setup Cache
echo ""
if [ -d "$CACHE_DIR" ]; then
    echo "🔄 Updating Superpowers cache..."
    git -C "$CACHE_DIR" pull -q
else
    echo "⬇️  Cloning Superpowers to $CACHE_DIR..."
    git clone -q "$REPO_URL" "$CACHE_DIR"
fi

# 2. Generate Slash Commands
echo "🛠️  Generating Slash Commands..."
mkdir -p "$COMMANDS_DIR"

count=0
for entry in "${SKILLS[@]}"; do
    IFS=':' read -r skill_dir cmd_name desc <<< "$entry"
    skill_file="$CACHE_DIR/skills/$skill_dir/SKILL.md"
    toml_file="$COMMANDS_DIR/$cmd_name.toml"

    if [ -f "$skill_file" ]; then
        # We use Gemini CLI's native @{path} syntax to include the skill content.
        # This means we don't duplicate the text, we just point to the cache.
        cat > "$toml_file" <<EOF
description = "$desc"
prompt = """
@{${skill_file}}

Task: {{args}}
"""
EOF
        echo "   ✓ /$cmd_name -> $skill_dir"
        ((count++))
    else
        echo "   ⚠️  Missing skill: $skill_dir"
    fi
done

# 3. Inject Global Context
echo ""
echo "📝 Updating Global Context ($CONTEXT_FILE)..."
mkdir -p "$GEMINI_ROOT"
touch "$CONTEXT_FILE"

MARKER="<!-- SUPERPOWERS-PROTOCOL -->"
PROTOCOL=$(cat <<EOF
$MARKER
# SUPERPOWERS PROTOCOL
You are an autonomous coding agent operating on a strict "Loop of Autonomy."

## CORE DIRECTIVE
1. **PERCEIVE**: Read \`plan.md\` if it exists. Do not act without checking the plan.
2. **ACT**: Execute the next unchecked step in the plan.
3. **UPDATE**: Check off the step in \`plan.md\` when verified.
4. **LOOP**: If the task is large, do not stop. Continue to the next step.

## SKILLS (Slash Commands)
You have access to native slash commands that enforce best practices.
- Use \`/plan\` (writing-plans) to create detailed plans.
- Use \`/tdd\` (test-driven-development) to write code. NEVER write code without a failing test.
- Use \`/investigate\` (systematic-debugging) when tests fail.
- Use \`/verify\` (verification-before-completion) to double-check work.

If you are stuck, write a theory in \`scratchpad.md\`.
$MARKER
EOF
)

# Idempotent injection: Replace existing block or append if new
if grep -q "$MARKER" "$CONTEXT_FILE"; then
    # Perl used for robust multiline replacement of the block between markers
    perl -i -0777 -pe "s/\Q$MARKER\E.*?\Q$MARKER\E/$(echo "$PROTOCOL" | sed 's/[\/&]/\\&/g' | sed 's/$/\\n/' | tr -d '\n')/s" "$CONTEXT_FILE"
    echo "   ✓ Updated existing protocol definition"
else
    echo -e "\n$PROTOCOL" >> "$CONTEXT_FILE"
    echo "   ✓ Appended protocol to context file"
fi

echo ""
echo "✅ Installation Complete ($count commands installed)"
echo "==================================="
echo "Type 'gemini' to start, then try:"
echo "  /plan Build a simple hello world script"