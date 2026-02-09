# Gemini CLI Intent Inference Test Suite

**Created:** 2026-02-08  
**Status:** ✅ Complete and ready to use

## Overview

This test suite validates that Gemini CLI can properly infer skill intent from natural language prompts **without requiring slash commands**.

## Purpose

We know slash commands (`/brainstorm`, `/plan`, etc.) work well in Gemini CLI. This test suite validates that the **Superpowers framework also works through natural language intent inference** - the LLM should recognize when to invoke skills based on conversational prompts alone.

## Test Coverage

### All 14 Superpowers Skills Tested

1. **brainstorming** - "Let's brainstorm different solutions..."
2. **writing-plans** - "I need a detailed implementation plan..."
3. **executing-plans** - "Continue working through the plan..."
4. **test-driven-development** - "Let's use test-driven development approach..."
5. **systematic-debugging** - "Help me investigate this systematically..."
6. **verification-before-completion** - "Verify everything is working correctly..."
7. **using-git-worktrees** - "What's the best git workflow..."
8. **finishing-a-development-branch** - "What are the final steps before merge..."
9. **requesting-code-review** - "How should I request a code review..."
10. **receiving-code-review** - "I received code review feedback..."
11. **subagent-driven-development** - "What's the most efficient way to execute this plan..."
12. **dispatching-parallel-agents** - "What's the best approach to work simultaneously..."
13. **writing-skills** - "How should I structure and write this skill..."
14. **using-superpowers** - "What should I know about working effectively..."

## Usage

### Running the Test Suite

```bash
./scripts/test-gemini-cli-inference.sh
```

### Prerequisites

- Gemini CLI installed (`gemini --version` works)
- Superpowers installed (`.superpowers/skills/` directory exists)
- Clean test environment (script handles cleanup automatically)

### What Happens

1. **Setup Phase**
   - Verifies Gemini CLI and Superpowers installation
   - Cleans test environment (removes `plan.md`, `scratchpad.md`, etc.)
   - Creates results directory: `tmp/gemini-cli-test-results/`

2. **Execution Phase**
   - Runs 14 tests sequentially
   - Each test uses a natural language prompt (no slash commands)
   - Captures Gemini CLI output to individual files
   - Logs all activity for debugging

3. **Report Generation**
   - Creates comprehensive markdown report
   - Includes expected vs actual behaviors
   - Provides scoring guide (0-5 points per test)
   - Generates comparison framework

### Output Files

```
tmp/gemini-cli-test-results/
├── gemini-inference-report-YYYYMMDD-HHMMSS.md  # Main report
├── gemini-test-raw-YYYYMMDD-HHMMSS.log         # Raw log
├── test-1-output.txt                            # Individual results
├── test-2-output.txt
├── ...
└── test-14-output.txt
```

## Scoring Guide

After running tests, manually review each output and score:

- **5 points:** Perfect skill match - correct behavior demonstrated
- **4 points:** Good match - most expected behaviors present
- **3 points:** Partial match - some correct behaviors, some missing
- **2 points:** Weak match - generic response, minimal skill-specific behavior
- **1 point:** Wrong approach - different skill or no skill recognition
- **0 points:** Failed or no response

**Maximum possible:** 70 points (14 tests × 5 points)

## Scoring Baseline

- **Maximum Score:** 70 points (14 tests × 5 points each)
- **Perfect Performance:** All skills correctly inferred and executed from natural language
- **Gemini CLI:** This test suite establishes the baseline for intent inference quality

## Expected Behaviors Per Test

Each test has specific expected behaviors to check for:

| Test | Expected Behaviors |
|------|-------------------|
| 1 (brainstorming) | asks clarifying questions \| explores multiple approaches \| does NOT write plan.md yet |
| 2 (writing-plans) | creates plan.md \| structured steps \| does NOT start implementation |
| 3 (executing-plans) | reads plan.md \| identifies next unchecked step \| updates checkboxes |
| 4 (test-driven-development) | writes failing test FIRST \| then implements function \| test before code |
| 5 (systematic-debugging) | asks for error details \| creates scratchpad.md \| gathers evidence |
| 6 (verification-before-completion) | runs tests \| checks requirements \| provides checklist |
| 7 (using-git-worktrees) | mentions git worktree \| suggests isolation \| worktree commands |
| 8 (finishing-a-development-branch) | suggests cleanup steps \| mentions merging \| final verification |
| 9 (requesting-code-review) | suggests PR creation \| explains review process |
| 10 (receiving-code-review) | addresses feedback systematically \| explains changes |
| 11 (subagent-driven-development) | suggests using subagents \| mentions delegation \| parallel execution |
| 12 (dispatching-parallel-agents) | identifies independence \| suggests parallel execution |
| 13 (writing-skills) | explains skill structure \| mentions SKILL.md \| provides template |
| 14 (using-superpowers) | explains framework \| lists available skills \| describes workflow |

## Troubleshooting

### No Output or Empty Responses

**Cause:** Gemini CLI may not be responding properly  
**Fix:** Check if `gemini` accepts prompts via stdin: `echo "test" | gemini`

### Wrong Skills Triggered

**Cause:** Skills not properly embedded in `.gemini/GEMINI.md`  
**Fix:** Verify `<available_skills>` block contains all 14 skills with complete descriptions

### Generic Responses (Low Scores)

**Cause:** Intent inference not working - LLM doesn't recognize skill triggers  
**Fix:** 
1. Check skill `<description>` clarity in GEMINI.md
2. Ensure skill trigger words are present
3. Review skill `<instructions>` for specificity

### Test Failures

**Cause:** CLI execution errors or setup issues  
**Fix:**
1. Run `./scripts/verify-installation.sh` first
2. Check Gemini CLI version compatibility
3. Review error logs in test output files

## Integration with CI/CD

This test suite can be integrated into continuous integration:

```bash
# Run tests
./scripts/test-gemini-cli-inference.sh

# Check exit code
if [ $? -eq 0 ]; then
    echo "Tests completed - review results for scoring"
else
    echo "Tests failed - check logs"
    exit 1
fi
```

Note: Manual scoring is still required for quality assessment.

## Next Steps

1. **Run Initial Baseline**
   ```bash
   ./scripts/test-gemini-cli-inference.sh
   ```

2. **Score All Tests**
   - Review each test-N-output.txt
   - Assign 0-5 score per test
   - Document total score

3. **Analyze Results**
   - Calculate total score (out of 70)
   - Identify which skills infer correctly
   - Document gaps or issues

4. **Fix Issues**
   - If scores are low, investigate `.gemini/GEMINI.md`
   - Verify all skills are embedded properly
   - Check skill descriptions are clear and specific

5. **Document Findings**
   - Update issue #6 (or relevant tracking issue)
   - Share comparison with team
   - Propose improvements if needed

## Related Documentation

- [TESTING.md](../docs/TESTING.md) - Complete testing guide
- [skill-intent-inference-tests.md](../docs/plans/2026-02-08-skill-intent-inference-tests.md) - Audit findings
- [SKILLS_REFERENCE.md](../docs/SKILLS_REFERENCE.md) - All skills documentation

## References

- **Skills Source:** `.superpowers/skills/*/SKILL.md` files
- **Test Methodology:** Natural language intent inference validation
