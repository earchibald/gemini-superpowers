# Testing Guide

## Automated Tests

### Installation Verification

```bash
./scripts/verify-installation.sh
```

Checks:
- Cache exists at `~/.cache/superpowers`
- Instructions file present
- All 14 prompts installed
- Frontmatter format valid

### Gemini CLI Intent Inference Tests

```bash
./scripts/test-gemini-cli-inference.sh
```

**Purpose:** Validates that Gemini CLI can infer skill intent from natural language prompts WITHOUT requiring slash commands.

**What it tests:**
- All 14 Superpowers skills using natural language triggers
- Intent recognition and skill invocation
- Skill behavior matches expected patterns
- No false positives (wrong skills triggered)

**Output:**
- Individual test outputs: `tmp/gemini-cli-test-results/test-N-output.txt`
- Comprehensive report: `tmp/gemini-cli-test-results/gemini-inference-report-*.md`
- Raw log: `tmp/gemini-cli-test-results/gemini-test-raw-*.log`

**Manual scoring required:**
After running the script, review each test output and score 0-5 points:
- 5: Perfect skill match with correct behavior
- 4: Good match, most behaviors present
- 3: Partial match, some behaviors missing
- 2: Weak match, generic response
- 1: Wrong skill or no skill recognition
- 0: Failed or no response

**Scoring baseline:**
- Maximum score: 70 points (14 tests × 5 points)
- Perfect performance: All skills correctly inferred

**Troubleshooting:**
If tests fail, check `.gemini/GEMINI.md` to verify all skills are properly embedded in the `<available_skills>` block.

## Manual Tests

### Test Slash Command Availability

1. Start Gemini CLI: `gemini`
2. Type `/` to see command list
3. Verify all 14 superpowers commands appear:
   - /brainstorm
   - /plan
   - /execute
   - /tdd
   - /investigate
   - /verify
   - /worktree
   - /finish
   - /review
   - /receive
   - /subagent
   - /dispatch
   - /newskill
   - /superpowers

### Test Skill Invocation

1. Type `/plan` in Gemini CLI
2. Verify skill content loads
3. Check skill instructions are followed

### Test Update Flow

1. Run `./install-superpowers.sh` again
2. Verify idempotent behavior
3. Check logs show "Updating" not "Installing"
4. Verify no file duplication

## Integration Tests

### End-to-End Workflow

1. Use `/brainstorm` to design a feature
2. Use `/plan` to create implementation plan
3. Use `/worktree` to create isolated workspace
4. Use `/tdd` to implement first task
5. Use `/review` to check work
6. Use `/verify` to ensure tests pass
7. Use `/finish` to complete workflow

## Troubleshooting

### Commands Not Appearing

- Restart Gemini CLI
- Check skills exist: `ls .superpowers/skills/`
- Verify SKILL.md files: `ls .superpowers/skills/*/SKILL.md`

### Cache Not Updating

- Manual update: `cd ~/.cache/superpowers && git pull`
- Check network: `ping github.com`

### Incorrect Behavior

- Check GEMINI.md: `cat .gemini/GEMINI.md`
- Verify skills are embedded in <available_skills> block
- Re-run installer: `./install-superpowers.sh`

## Test Coverage

### Files Tested
- ✓ install-superpowers.sh - Installation script
- ✓ scripts/verify-installation.sh - Verification script
- ✓ scripts/test-gemini-cli-inference.sh - Intent inference tests
- ✓ .superpowers/skills/*/SKILL.md - All 14 skill files

### Scenarios Tested
- ✓ Fresh installation
- ✓ Update existing installation
- ✓ Verification script execution
- ✓ Prompt file structure
- ✓ Command naming conflicts avoided

### Platform Support
- ✓ macOS (tested)
- ✓ Linux (should work - bash script)
- ⚠️  Windows (may need WSL or Git Bash)
