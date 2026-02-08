# Gemini Assets Audit and Fix

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Remove VS Code-specific artifacts and update documentation to be accurate for `gemini-superpowers`, ensuring full Gemini-focused correctness across the repository.

**Architecture:** The plan involves deleting irrelevant files and directories, and performing targeted text replacements within documentation files.

**Tech Stack:** `bash` commands (`rm`, `grep`), `git` (for commits).

---

### Task 1: Remove VS Code-specific files

**Files:**
- Delete: `/Users/earchibald/work/gemini-superpowers/.github/copilot-instructions.md`
- Delete: `/Users/earchibald/work/gemini-superpowers/.github/prompts/` (entire directory)
- Delete: `/Users/earchibald/work/gemini-superpowers/scripts/test-installer.sh`

**Step 1: Delete `.github/copilot-instructions.md`**

Command explanation: Removes the Copilot-specific instructions file that is not relevant for Gemini CLI.
Run: `rm /Users/earchibald/work/gemini-superpowers/.github/copilot-instructions.md`

**Step 2: Delete `.github/prompts/` directory**

Command explanation: Removes the directory containing VS Code-specific prompt files, which are not used by the Gemini CLI integration.
Run: `rm -rf /Users/earchibald/work/gemini-superpowers/.github/prompts/`

**Step 3: Delete `scripts/test-installer.sh`**

Command explanation: Removes the installer test script that is specific to the VS Code implementation and irrelevant for Gemini CLI.
Run: `rm /Users/earchibald/work/gemini-superpowers/scripts/test-installer.sh`

**Step 4: Commit**

```bash
git rm /Users/earchibald/work/gemini-superpowers/.github/copilot-instructions.md /Users/earchibald/work/gemini-superpowers/.github/prompts/ /Users/earchibald/work/gemini-superpowers/scripts/test-installer.sh
git commit -m "feat: Remove VS Code-specific files and directories"
```

---

### Task 2: Update `docs/SKILLS_REFERENCE.md` for Gemini

**Files:**
- Modify: `/Users/earchibald/work/gemini-superpowers/docs/SKILLS_REFERENCE.md`

**Step 1: Update "VS Code" references to "Gemini CLI"**

Instruction: Replace all occurrences of "VS Code slash commands" with "Gemini CLI slash commands" and "GitHub Copilot Chat" with "Gemini CLI".
Old String Example: `Complete reference for all 14 Superpowers skills available as VS Code slash commands.`
New String Example: `Complete reference for all 14 Superpowers skills available as Gemini CLI slash commands.`

**Step 2: Adapt "Command Mapping" table**

Instruction: Transform the "Command Mapping" table from "Original Skill" vs "VS Code Command" to "Original Skill" vs "Gemini Command" using the mappings defined in `gemini-superpowers/README.md`. Also remove the "Reason for Rename" column, as it's less relevant for Gemini.
This will involve constructing the new table content and replacing the old one.

**Step 3: Remove "Why Rename Commands?" section**

Instruction: Delete the section explaining the reasons for command renaming, as it's specifically for VS Code.

**Step 4: Update "Typical Workflows"**

Instruction: Replace VS Code-specific command names (e.g., `/write-plan`) with their Gemini equivalents (e.g., `/plan`).

**Step 5: Update "Tips & Best Practices"**

Instruction: Replace VS Code-specific command names (e.g., `/write-plan`) with their Gemini equivalents (e.g., `/plan`).

**Step 6: Update "Version Information"**

Instruction: Change "as implemented for VS Code" to "as implemented for Gemini CLI".

**Step 7: Commit**

```bash
git add /Users/earchibald/work/gemini-superpowers/docs/SKILLS_REFERENCE.md
git commit -m "docs: Update SKILLS_REFERENCE.md for Gemini CLI"
```