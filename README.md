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
# Clone this repository
git clone https://github.com/earchibald/gemini-superpowers.git
cd gemini-superpowers

# Run the installer
./install-superpowers.sh

# Start Gemini CLI
gemini
```

### How Installation Works

The `install-superpowers.sh` script sets up your Gemini CLI environment by:

1.  **Global Cache**: Clones the core Superpowers framework to a shared cache directory (`~/.cache/superpowers`), centralizing skill definitions for efficiency across all Gemini CLI instances.
2.  **Native Commands**: Generates `.toml` slash commands directly within your `~/.gemini/commands/` directory. These commands provide seamless, native access to the cached Superpowers skills.
3.  **Autonomous Protocol**: Injects the "Loop of Autonomy" protocol into your `~/.gemini/GEMINI.md` file. This crucial step guides Gemini CLI's behavior to strictly follow the Superpowers workflow and best practices.

**Result:** Your Gemini CLI is transformed into an autonomous coding agent, leveraging Superpowers' structured workflows through deep native integration.

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
