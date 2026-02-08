#!/usr/bin/env bash
set -e

# ==============================================================================
# 🦸 GEMINI CLI SUPERPOWERS INSTALLER
# ==============================================================================
# "Radically Simple" Adapter for Google Gemini CLI
#
# 1. Clones obra/superpowers to ~/.cache/superpowers
# 2. Generates native .toml slash commands in ~/.gemini/commands/
# 3. Injects the "Loop of Autonomy" protocol into GEMINI.md (local or global)
# ==============================================================================

# --- Configuration ---
REPO_URL="https://github.com/obra/superpowers"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/superpowers"
GEMINI_ROOT="$HOME/.gemini" # Base for global Gemini CLI config
COMMANDS_DIR="$GEMINI_ROOT/commands" # Commands are currently always global

# Default to workspace-local installation
INSTALL_GLOBAL=false
WORKSPACE_ROOT="$(pwd)" # Current working directory is the workspace root

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --user)
            INSTALL_GLOBAL=true
            ;;
        *)
            echo "Unknown argument: $arg"
            exit 1
            ;;
    esac
done

if [ "$INSTALL_GLOBAL" = true ]; then
    GEMINI_MD_INSTALL_PATH="$GEMINI_ROOT/GEMINI.md"
    GEMINI_SKILLS_BASE_DIR="$GEMINI_ROOT/.superpowers/skills"
    echo "🌍 Installing superpowers globally to $HOME..."
else
    # Workspace-local installation
    mkdir -p "$WORKSPACE_ROOT/.gemini" # Ensure .gemini exists in workspace
    GEMINI_MD_INSTALL_PATH="$WORKSPACE_ROOT/.gemini/GEMINI.md"
    GEMINI_SKILLS_BASE_DIR="$WORKSPACE_ROOT/.gemini/.superpowers/skills"
    echo "📁 Installing superpowers workspace-locally to $WORKSPACE_ROOT..."
fi

CONTEXT_FILE="$GEMINI_MD_INSTALL_PATH" # Use the determined path for GEMINI.md

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

# 1b. Setup Skills in Gemini config directory
echo "📦 Installing skills to $GEMINI_SKILLS_BASE_DIR..."
mkdir -p "$GEMINI_SKILLS_BASE_DIR"
for skill_dir in "$CACHE_DIR"/skills/*/; do
    skill_name=$(basename "$skill_dir")
    cp -r "$skill_dir" "$GEMINI_SKILLS_BASE_DIR/$skill_name"
done

# 2. Generate Slash Commands
echo "🛠️  Generating Slash Commands..."
mkdir -p "$COMMANDS_DIR" # Still global, as Gemini CLI currently only reads global commands

count=0
for entry in "${SKILLS[@]}"; do
    IFS=':' read -r skill_dir cmd_name desc <<< "$entry"
    
    # Skill file path: relative to where gemini is invoked for workspace-local, or absolute for global.
    if [ "$INSTALL_GLOBAL" = true ]; then
        skill_file="$GEMINI_SKILLS_BASE_DIR/$skill_dir/SKILL.md"
    else
        # For workspace-local, the path needs to be relative to the workspace root for the @{} syntax to work.
        skill_file=".gemini/.superpowers/skills/$skill_dir/SKILL.md"
    fi
    toml_file="$COMMANDS_DIR/$cmd_name.toml"

    if [ -f "$GEMINI_SKILLS_BASE_DIR/$skill_dir/SKILL.md" ]; then
        # We use Gemini CLI's native @{path} syntax with a pointer to skills.
        # Note: This script assumes Gemini CLI is invoked from the workspace root for local paths.
        cat > "$toml_file" <<EOF
description = "$desc"
prompt = """
@{${skill_file}}

Task: {{args}}
"""
EOF
        echo "   ✓ /$cmd_name -> $skill_dir"
        ((++count))
    else
        echo "   ⚠️  Missing skill: $skill_dir"
    fi
done

# 3. Inject Global Context

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
<!-- SUPERPOWERS-PROTOCOL -->

## Available Agent Skills

You have access to the following specialized skills. To activate a skill and receive its detailed instructions, you can call the \`activate_skill\` tool with the skill's name.

<available_skills>
  <skill>
    <name>skill-creator</name>
    <description>Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Gemini CLI's capabilities with specialized knowledge, workflows, or tool integrations.</description>
    <location>/opt/homebrew/Cellar/gemini-cli/0.27.3/libexec/lib/node_modules/@google/gemini-cli/node_modules/@google/gemini-cli-core/dist/src/skills/builtin/skill-creator/SKILL.md</location>
  </skill>
  <skill>
    <name>writing-plans</name>
    <description>Use when you have a spec or requirements for a multi-step task, before touching code. Create comprehensive implementation plans, documenting everything an engineer needs to know.</description>
    <instructions>
# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** \`docs/plans/YYYY-MM-DD-&lt;feature-name&gt;.md\`

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

\`\`\`markdown
# [Feature Name] Implementation Plan

&gt; **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
\`\`\`

## Task Structure

\`\`\`markdown
### Task N: [Component Name]

**Files:**
- Create: \`exact/path/to/file.py\`
- Modify: \`exact/path/to/existing.py:123-145\`
- Test: \`tests/exact/path/to/test.py\`

**Step 1: Write the failing test**

\`\`\`python
def test_specific_behavior():
    result = function(input)
    assert result == expected
\`\`\`

**Step 2: Run test to verify it fails**

Run: \`pytest tests/path/test.py::test_name -v\`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

\`\`\`python
def function(input):
    return expected
\`\`\`

**Step 4: Run test to verify it passes**

Run: \`pytest tests/path/test.py::test_name -v\`
Expected: PASS

**Step 5: Commit**

\`\`\`bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
\`\`\`
\`\`\`

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills with @ syntax
- DRY, YAGNI, TDD, frequent commits

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to \`docs/plans/&lt;filename&gt;&gt;.md\`. Two execution options:**

**1. Subagent-Driven (this session)** - I dispatch fresh subagent per task, review between tasks, fast iteration

**2. Parallel Session (separate)** - Open new session with executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Stay in this session
- Fresh subagent per task + code review

**If Parallel Session chosen:**
- Guide them to open new session in worktree
- **REQUIRED SUB-SKILL:** New session uses superpowers:executing-plans
    </instructions>
  </skill>
</available_skills>
EOF
)

# Idempotent injection: Replace existing block or append if new
if grep -q "$MARKER" "$CONTEXT_FILE"; then
    # Perl used for robust multiline replacement of the block between markers
    perl -i -0777 -pe "s/\Q$MARKER\E.*?\Q$MARKER\E/$(echo "$PROTOCOL" | sed 's/[\/&]/\\&/g' | sed 's/$/\\n/' | tr -d '\n')/s" "$CONTEXT_FILE"
    echo "   ✓ Updated existing protocol definition at $CONTEXT_FILE"
else
    echo -e "\n$PROTOCOL" >> "$CONTEXT_FILE"
    echo "   ✓ Appended protocol to context file at $CONTEXT_FILE"
fi

echo ""
echo "✅ Installation Complete ($count commands installed)"
echo "==================================="
echo "Type 'gemini' to start, then try:"
echo "  /plan Build a simple hello world script"