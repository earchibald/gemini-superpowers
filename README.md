# Gemini CLI Superpowers

An implementation of the [Superpowers](https://github.com/obra/superpowers) framework for Google Gemini CLI, providing all 14 core skills as native slash commands.

---

## What is Superpowers?

Superpowers is a complete software development workflow for coding agents, built on a set of composable "skills" that enforce best practices like TDD, systematic debugging, and comprehensive planning.

---

## 🙏 Credit & Support

**This project exists because of [Jesse Vincent (@obra)](https://github.com/obra) and the incredible [Superpowers](https://github.com/obra/superpowers) framework.**

Jesse created a paradigm-shifting approach to agent-driven development—systematic, principled, and focused on evidence over assumptions. This Gemini CLI implementation is built entirely on that foundation.

**If you find Superpowers valuable:**
- ⭐ **Star the original** [Superpowers repository](https://github.com/obra/superpowers)
- 📖 **Read the original** [Superpowers project](https://github.com/obra/superpowers) for the complete vision
- 🙌 **Support Jesse's work** - follow [@obra](https://github.com/obra) and contribute to the original project

The Superpowers approach transforms how we think about code quality, testing, and agent collaboration. Thank you, Jesse, for creating something that genuinely improves how we build software.

---

## Installation

```bash
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
```

### How Installation Works

The installer uses a **Superpowers framework integration approach**:

1.  **Global Cache**: Clones Superpowers to `~/.cache/superpowers` (shared across workspaces).
2.  **Command Generation**: Generates native Gemini CLI slash commands (`.toml` files) that point to the cached skills.
3.  **Protocol Injection**: Injects the "Loop of Autonomy" protocol into your `~/.gemini/GEMINI.md` to guide Gemini CLI's behavior.

**Result:** Gemini CLI gains Superpowers functionality through a centralized cache and native command integration.

### Backup & Recovery

If a `.gemini` directory already exists, the installer will attempt to update existing commands and the protocol. If you need to revert, you can manually remove generated command files from `~/.gemini/commands/` and edit `~/.gemini/GEMINI.md`.

## Available Skills (14 Total)

All 14 Superpowers skills are available as slash commands:

- `/plan` - Create detailed implementation plans
- `/execute` - Execute plans with checkpoints
- `/brainstorm` - Refine ideas through dialogue
- `/tdd` - Enforce strict TDD cycles
- `/investigate` - Systematic debugging
- `/verify` - Verify fixes work
- `/worktree` - Create isolated workspaces
- `/finish` - Complete branch workflows
- `/review` - Request code review
- `/receive` - Respond to feedback
- `/subagent` - Task-by-task development
- `/dispatch` - Parallel agent workflows
- `/newskill` - Create new skills
- `/superpowers` - Learn the system

### 📖 Quick Reference

**Start here:** [docs/CHEATSHEET.md](docs/CHEATSHEET.md) - Quick one-liners for all 14 skills, workflow diagrams, and decision trees. Perfect for learning workflows and remembering what skill to use.

**Deep dive:** [docs/SKILLS_REFERENCE.md](docs/SKILLS_REFERENCE.md) - Detailed descriptions of each skill with examples and anti-patterns.

## Command Mapping

Some skills use different names to align with Gemini CLI conventions:

- `/plan` (instead of `/write-plan`)
- `/execute` (instead of `/execute-plan`)
- `/subagent` (instead of `/subagent-dev`)
- `/dispatch` (instead of `/dispatch-agents`)
- `/newskill` (instead of `/write-skill`)
- `/finish` (instead of `/finish-branch`)
- `/review` (instead of `/request-review`)
- `/receive` (instead of `/receive-review`)

## Verification

```bash
# After installation, open a new Gemini CLI session and try a command:
/superpowers
```

## Troubleshooting

### Skills Not Appearing in Slash Commands

1.  **Reload Gemini CLI**: Restart your terminal session or Gemini CLI client.
2.  **Check commands directory**: `ls -la ~/.gemini/commands/ | grep toml`
3.  **Verify 14 skills**: `ls -1 ~/.gemini/commands/*.toml | wc -l`
4.  **Re-run installer**: `./install-superpowers.sh`

### Broken Installation

To reset:

```bash
# Remove generated commands
rm -rf ~/.gemini/commands/

# Remove protocol injection (if present)
# You might need to manually edit ~/.gemini/GEMINI.md to remove the protocol block
# between <!-- SUPERPOWERS-PROTOCOL --> markers if it exists and is corrupted.

# Run installer again
./install-superpowers.sh
```

## Updating

```bash
./install-superpowers.sh
```

The installer is idempotent - run it anytime to update to the latest version.

## Economics: Superpowers for Cost-Effective Gemini CLI

Understanding the cost implications of using Gemini Superpowers is crucial. Gemini's pricing is primarily based on token usage for both input (prompts) and output (responses). The Superpowers framework, with its emphasis on structured prompts, iterative development, and subagent delegation, can influence your Gemini API costs in several ways:

- **Structured Prompting:** While Superpowers encourages more detailed and structured prompts (e.g., comprehensive plans, detailed TDD steps), this can lead to higher input token counts per interaction. However, these structured prompts aim to reduce the need for multiple clarifying interactions, potentially leading to a more efficient overall process.
- **Iterative Development:** The Red-Green-Refactor cycle and systematic debugging often involve several turns of small, focused interactions. Each turn consumes tokens. The efficiency gained from a structured approach can offset the token cost of multiple turns by reducing overall time to resolution and minimizing irrelevant responses.
- **Subagent Usage:** When subagents are dispatched, they operate within their own context, which can increase the total token usage across multiple concurrent or sequential tasks. Monitoring subagent interactions will be important for cost management.

**Recommendations for Cost Optimization:**
- **Be Concise:** While structuring prompts, aim for clarity and conciseness to avoid unnecessary token consumption.
- **Leverage Context:** The Superpowers protocol encourages maintaining context through `plan.md` and `scratchpad.md`, which can help reduce redundant information in prompts.
- **Monitor Usage:** Regularly review your Gemini API usage to understand cost patterns and identify areas for optimization.

By promoting efficient workflows and focused interactions, Gemini Superpowers aims to provide significant value, but users should be mindful of token usage, especially with complex tasks and extensive subagent use.

## Philosophy

- **Test-Driven Development** - Write tests first, always
- **Systematic over ad-hoc** - Process over guessing
- **Complexity reduction** - Simplicity as primary goal
- **Evidence over claims** - Verify before declaring success

## Credits

Built on [Superpowers](https://github.com/obra/superpowers) by [@obra](https://github.com/obra).

## License

MIT License - see LICENSE file for details
