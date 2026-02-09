#!/usr/bin/env bash
set -e

################################################################################
# GEMINI CLI - SUPERPOWERS INFERENCE TEST AUTOMATION
################################################################################
# Runs the complete 14-skill inference test suite via Gemini CLI
# Tests natural language prompts WITHOUT slash commands to validate intent inference
# Captures output, scores responses, generates comparison report
# No manual copy-paste required
################################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RESULTS_DIR="${PROJECT_ROOT}/tmp/gemini-cli-test-results"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="${RESULTS_DIR}/gemini-inference-report-${TIMESTAMP}.md"
LOG_FILE="${RESULTS_DIR}/gemini-test-raw-${TIMESTAMP}.log"

# Test counter
TESTS_COMPLETED=0
TESTS_PASSED=0
TESTS_FAILED=0

################################################################################
# SETUP
################################################################################

echo -e "${BLUE}=== Gemini CLI Superpowers Inference Test Suite ===${NC}"
echo "Project: $PROJECT_ROOT"
echo "Results: $RESULTS_DIR"
echo ""

# Create results directory
mkdir -p "$RESULTS_DIR"

# Verify Gemini CLI is available
if ! command -v gemini &> /dev/null; then
    echo -e "${RED}❌ Gemini CLI not found. Please install it first.${NC}"
    exit 1
fi

GEMINI_VERSION=$(gemini --version 2>&1 | head -1 || echo "Version unknown")
echo -e "${GREEN}✓ Gemini CLI: ${GEMINI_VERSION}${NC}"

# Verify Superpowers is installed
if [ ! -d "$PROJECT_ROOT/.superpowers/skills" ]; then
    echo -e "${RED}❌ Superpowers not found. Run ./install-superpowers.sh first.${NC}"
    exit 1
fi

SKILL_COUNT=$(find "$PROJECT_ROOT/.superpowers/skills" -name "SKILL.md" | wc -l)
echo -e "${GREEN}✓ Superpowers installed: ${SKILL_COUNT} skills found${NC}"

# Clean environment
echo -e "\n${BLUE}Cleaning test environment...${NC}"
cd "$PROJECT_ROOT"
rm -f plan.md scratchpad.md 2>/dev/null || true
rm -rf docs/plans/*.md 2>/dev/null || true
git restore docs/plans/ 2>/dev/null || true
echo "✓ Cleaned plan.md, scratchpad.md, docs/plans/"

################################################################################
# TEST DEFINITIONS - ALL 14 SKILLS
################################################################################
# Testing natural language prompts WITHOUT slash commands
# to validate that intent inference works properly

declare -A TESTS=(
    [1]="brainstorming"
    [2]="writing-plans"
    [3]="executing-plans"
    [4]="test-driven-development"
    [5]="systematic-debugging"
    [6]="verification-before-completion"
    [7]="using-git-worktrees"
    [8]="finishing-a-development-branch"
    [9]="requesting-code-review"
    [10]="receiving-code-review"
    [11]="subagent-driven-development"
    [12]="dispatching-parallel-agents"
    [13]="writing-skills"
    [14]="using-superpowers"
)

declare -A PROMPTS=(
    [1]="I need to create a feature but I'm not sure about the best approach yet. Let's brainstorm different solutions before we start implementing anything. What are the key considerations?"
    
    [2]="I have a spec for a user authentication system with login, logout, and session management. I need a detailed implementation plan with specific steps and file changes. Can you help me create a comprehensive plan?"
    
    [3]="I have this plan in plan.md with several unchecked steps. Let's continue working through it systematically and implement the next item."
    
    [4]="I need to implement a password validation function that checks for minimum length, special characters, and numbers. Let's use test-driven development approach - write the test first, then implement."
    
    [5]="The tests are failing with 'TypeError: Cannot read property length of undefined' but I'm not sure where the issue is. Can you help me investigate this systematically?"
    
    [6]="I think I've completed the implementation. Before we mark this done, can you verify everything is working correctly and all requirements are met?"
    
    [7]="I'm about to start working on a new feature for user authentication. What's the best git workflow to keep my changes isolated?"
    
    [8]="I've finished implementing the feature in my branch and all tests pass. What are the final steps before I can merge this?"
    
    [9]="I've completed the implementation and want to get feedback from the team. How should I request a code review?"
    
    [10]="I just received code review feedback with several comments and change requests. How should I address these systematically?"
    
    [11]="I have a large plan with multiple independent implementation steps. What's the most efficient way to execute this?"
    
    [12]="I need to handle three completely independent tasks: update dependencies, fix a bug, and add documentation. What's the best approach to work on these simultaneously?"
    
    [13]="I want to create a new skill for the Superpowers framework that helps with API integration. How should I structure and write this skill?"
    
    [14]="I'm new to this project and want to understand how to work effectively with the available tools and skills. What should I know?"
)

declare -A EXPECTED_BEHAVIORS=(
    [1]="asks clarifying questions | explores multiple approaches | mentions brainstorming | does NOT write plan.md yet"
    [2]="creates plan.md | structured steps | mentions planning | does NOT start implementation"
    [3]="reads plan.md | identifies next unchecked step | works on specific item | updates checkboxes"
    [4]="writes failing test FIRST | then implements function | mentions TDD | test before code"
    [5]="asks for error details | requests relevant code | creates scratchpad.md | gathers evidence systematically"
    [6]="runs tests | checks requirements | verifies completeness | provides checklist | does NOT mark complete prematurely"
    [7]="mentions git worktree | suggests isolation | explains branching workflow | worktree commands"
    [8]="suggests cleanup steps | mentions merging | final verification | branch hygiene"
    [9]="suggests PR creation | explains review process | mentions documentation | creates review request"
    [10]="addresses feedback systematically | mentions iteration | explains changes | updates based on comments"
    [11]="suggests using subagents | mentions delegation | parallel execution | breaking down tasks"
    [12]="identifies independence | suggests parallel execution | mentions dispatching | creates separate agents"
    [13]="explains skill structure | mentions SKILL.md | describes components | provides template"
    [14]="explains Superpowers framework | lists available skills | describes workflow | mentions slash commands"
)

################################################################################
# TEST EXECUTION
################################################################################

run_test() {
    local test_num=$1
    local test_name=${TESTS[$test_num]}
    local prompt=${PROMPTS[$test_num]}
    local expected=${EXPECTED_BEHAVIORS[$test_num]}
    
    TESTS_COMPLETED=$((TESTS_COMPLETED + 1))
    
    echo -e "\n${BLUE}Test $test_num: $test_name${NC}"
    echo "═════════════════════════════════════════════════"
    
    # Create temp for output
    local output_file="${RESULTS_DIR}/test-${test_num}-output.txt"
    
    # Run gemini with prompt
    # Note: Adjust flags based on how gemini CLI accepts prompts
    echo -n "Running... "
    
    # Try to run gemini CLI with the prompt
    # Gemini CLI may use different flags - adjust as needed
    if echo "$prompt" | gemini --approval-mode yolo 2>&1 > "$output_file"; then
        echo -e "${GREEN}✓${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        local exit_code=$?
        echo -e "${YELLOW}⚠ Exit code: $exit_code${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        # Still capture partial output if any
        if [ ! -s "$output_file" ]; then
            echo "Command failed with exit code: $exit_code" > "$output_file"
        fi
    fi
    
    # Check output isn't empty
    if [ ! -s "$output_file" ]; then
        echo -e "${YELLOW}⚠ Warning: Empty response${NC}"
    fi
    
    # Save output for manual review
    {
        echo ""
        echo "################################################################################"
        echo "# Test $test_num: $test_name"
        echo "################################################################################"
        echo "# Prompt:"
        echo "$prompt"
        echo ""
        echo "# Expected behaviors: $expected"
        echo ""
        echo "# Raw output:"
        echo ""
        cat "$output_file"
        echo ""
    } >> "$LOG_FILE"
    
    local line_count=$(wc -l < "$output_file" 2>/dev/null || echo "0")
    echo "Output: $line_count lines"
    echo "Expected: $expected"
    
    return 0
}

# Pre-test setup for Test 3 (needs plan.md with unchecked items)
setup_test_3() {
    cat > "${PROJECT_ROOT}/plan.md" << 'EOF'
# User Authentication Implementation Plan

## Context
Building a secure authentication system with session management.

## Steps
- [x] Research authentication approaches
- [x] Choose JWT-based approach
- [ ] Create user model with password hashing
- [ ] Implement login endpoint
- [ ] Add session management
- [ ] Write authentication tests
- [ ] Add logout functionality

## Notes
- Use bcrypt for password hashing
- Store JWT tokens securely
EOF
    echo "Created plan.md for Test 3"
}

################################################################################
# RUN ALL TESTS
################################################################################

echo -e "\n${BLUE}Starting 14-skill inference test suite...${NC}"
echo -e "${YELLOW}Note: These tests use natural language WITHOUT slash commands${NC}"
echo -e "${YELLOW}to validate that intent inference works properly.${NC}\n"

run_test 1
run_test 2
setup_test_3
run_test 3
run_test 4
run_test 5
run_test 6
run_test 7
run_test 8
run_test 9
run_test 10
run_test 11
run_test 12
run_test 13
run_test 14

################################################################################
# GENERATE REPORT
################################################################################

echo -e "\n${BLUE}Generating report...${NC}"

cat > "$REPORT_FILE" << EOF
# Gemini CLI - Superpowers Inference Test Report

**Date:** $(date)
**Timestamp:** $TIMESTAMP
**Gemini Version:** $GEMINI_VERSION
**Skills Found:** $SKILL_COUNT

---

## Executive Summary

**Tests completed:** $TESTS_COMPLETED/14  
**Tests with responses:** $TESTS_PASSED/14  
**Tests failed/partial:** $TESTS_FAILED/14

### Test Objective

Validate that Gemini CLI can **infer intent** from natural language prompts and invoke the appropriate Superpowers skills **WITHOUT requiring slash commands**.

### Test Results Overview

| Test | Skill Name | Status |
|------|------------|--------|
| 1 | brainstorming | $([ -s "${RESULTS_DIR}/test-1-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 2 | writing-plans | $([ -s "${RESULTS_DIR}/test-2-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 3 | executing-plans | $([ -s "${RESULTS_DIR}/test-3-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 4 | test-driven-development | $([ -s "${RESULTS_DIR}/test-4-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 5 | systematic-debugging | $([ -s "${RESULTS_DIR}/test-5-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 6 | verification-before-completion | $([ -s "${RESULTS_DIR}/test-6-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 7 | using-git-worktrees | $([ -s "${RESULTS_DIR}/test-7-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 8 | finishing-a-development-branch | $([ -s "${RESULTS_DIR}/test-8-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 9 | requesting-code-review | $([ -s "${RESULTS_DIR}/test-9-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 10 | receiving-code-review | $([ -s "${RESULTS_DIR}/test-10-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 11 | subagent-driven-development | $([ -s "${RESULTS_DIR}/test-11-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 12 | dispatching-parallel-agents | $([ -s "${RESULTS_DIR}/test-12-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 13 | writing-skills | $([ -s "${RESULTS_DIR}/test-13-output.txt" ] && echo "✓ Response" || echo "❌ No output") |
| 14 | using-superpowers | $([ -s "${RESULTS_DIR}/test-14-output.txt" ] && echo "✓ Response" || echo "❌ No output") |

---

## Detailed Test Outputs

### Test 1: brainstorming

**Prompt:** ${PROMPTS[1]}

**Expected:** ${EXPECTED_BEHAVIORS[1]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-1-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-1-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-1-output.txt)")
\`\`\`

---

### Test 2: writing-plans

**Prompt:** ${PROMPTS[2]}

**Expected:** ${EXPECTED_BEHAVIORS[2]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-2-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-2-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-2-output.txt)")
\`\`\`

---

### Test 3: executing-plans

**Prompt:** ${PROMPTS[3]}

**Expected:** ${EXPECTED_BEHAVIORS[3]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-3-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-3-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-3-output.txt)")
\`\`\`

---

### Test 4: test-driven-development

**Prompt:** ${PROMPTS[4]}

**Expected:** ${EXPECTED_BEHAVIORS[4]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-4-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-4-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-4-output.txt)")
\`\`\`

---

### Test 5: systematic-debugging

**Prompt:** ${PROMPTS[5]}

**Expected:** ${EXPECTED_BEHAVIORS[5]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-5-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-5-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-5-output.txt)")
\`\`\`

---

### Test 6: verification-before-completion

**Prompt:** ${PROMPTS[6]}

**Expected:** ${EXPECTED_BEHAVIORS[6]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-6-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-6-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-6-output.txt)")
\`\`\`

---

### Test 7: using-git-worktrees

**Prompt:** ${PROMPTS[7]}

**Expected:** ${EXPECTED_BEHAVIORS[7]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-7-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-7-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-7-output.txt)")
\`\`\`

---

### Test 8: finishing-a-development-branch

**Prompt:** ${PROMPTS[8]}

**Expected:** ${EXPECTED_BEHAVIORS[8]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-8-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-8-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-8-output.txt)")
\`\`\`

---

### Test 9: requesting-code-review

**Prompt:** ${PROMPTS[9]}

**Expected:** ${EXPECTED_BEHAVIORS[9]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-9-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-9-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-9-output.txt)")
\`\`\`

---

### Test 10: receiving-code-review

**Prompt:** ${PROMPTS[10]}

**Expected:** ${EXPECTED_BEHAVIORS[10]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-10-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-10-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-10-output.txt)")
\`\`\`

---

### Test 11: subagent-driven-development

**Prompt:** ${PROMPTS[11]}

**Expected:** ${EXPECTED_BEHAVIORS[11]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-11-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-11-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-11-output.txt)")
\`\`\`

---

### Test 12: dispatching-parallel-agents

**Prompt:** ${PROMPTS[12]}

**Expected:** ${EXPECTED_BEHAVIORS[12]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-12-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-12-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-12-output.txt)")
\`\`\`

---

### Test 13: writing-skills

**Prompt:** ${PROMPTS[13]}

**Expected:** ${EXPECTED_BEHAVIORS[13]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-13-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-13-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-13-output.txt)")
\`\`\`

---

### Test 14: using-superpowers

**Prompt:** ${PROMPTS[14]}

**Expected:** ${EXPECTED_BEHAVIORS[14]}

**Output:**
\`\`\`
$(cat "${RESULTS_DIR}/test-14-output.txt" 2>/dev/null | head -50)
$([ $(cat "${RESULTS_DIR}/test-14-output.txt" 2>/dev/null | wc -l) -gt 50 ] && echo "... (truncated, see full output in test-14-output.txt)")
\`\`\`

---

## Analysis Guide

### Manual Scoring (5-point scale per test)

For each test output, score 0-5 based on:

- **5 points:** Perfect skill match - correct behavior demonstrated
- **4 points:** Good match - most expected behaviors present
- **3 points:** Partial match - some correct behaviors, some missing
- **2 points:** Weak match - generic response, minimal skill-specific behavior
- **1 point:** Wrong approach - different skill or no skill recognition
- **0 points:** Failed or no response

### Critical Questions

1. **Skill Recognition:** Did Gemini identify the correct skill from natural language?
2. **Skill Execution:** Did it follow the skill's instructions properly?
3. **False Positives:** Any wrong skills triggered?
4. **Slash Command Requirement:** Were any slash commands mentioned/required?

### Comparison Baseline

Establish baseline scores for Gemini CLI inference quality. Perfect score would be 70/70 (5 points × 14 tests).

---

## Files Generated

- **This report:** \`${REPORT_FILE}\`
- **Raw log:** \`${LOG_FILE}\`
- **Individual outputs:** \`${RESULTS_DIR}/test-*-output.txt\`

---

## Next Steps

1. **Review Outputs:** Examine each test-N-output.txt file
2. **Score Tests:** Fill in manual scores (0-5 per test)
3. **Calculate Total:** Sum scores (max 70 points for 14 tests)
4. **Document Findings:** Update issue tracker with results
6. **Fix Issues:** If intent inference fails, check .gemini/GEMINI.md skill embeddings

---

**Test run completed at:** $(date)
EOF

echo -e "${GREEN}✓ Report generated: $REPORT_FILE${NC}"

################################################################################
# SUMMARY
################################################################################

echo ""
echo -e "${BLUE}=== Test Run Complete ===${NC}"
echo "Tests completed: $TESTS_COMPLETED/14"
echo "Responses captured: $TESTS_PASSED"
echo "Failed/partial: $TESTS_FAILED"
echo ""
echo "Results directory: $RESULTS_DIR"
echo "Full report: $REPORT_FILE"
echo "Raw log: $LOG_FILE"
echo "Individual outputs: test-*-output.txt files"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Review each test output in ${RESULTS_DIR}/"
echo "2. Score tests (0-5 scale) based on skill inference quality"
echo "3. Compare with Local Agent baseline (typically 35/35)"
echo "4. If tests fail, check .gemini/GEMINI.md for skill embeddings"
echo ""

exit 0
