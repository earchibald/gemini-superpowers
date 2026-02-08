# Gemini/VSC Parity Cleanup

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Further align `gemini-superpowers` repository with `vsc-superpowers` by removing unnecessary files and standardizing the license file name.

**Architecture:** The plan involves removing a specific file and renaming another in the `gemini-superpowers` repository to match the structure of `vsc-superpowers`.

**Tech Stack:** `bash` commands (`rm`, `mv`), `git` (for commits).

---

### Task 1: Remove `INSTALLATION_REPORT.md` from `gemini-superpowers`

**Files:**
- Delete: `/Users/earchibald/work/gemini-superpowers/INSTALLATION_REPORT.md`

**Step 1: Delete `INSTALLATION_REPORT.md`**

Command explanation: Deletes the `INSTALLATION_REPORT.md` file, as it is specific to the `gemini-superpowers` initial setup and not present in `vsc-superpowers`.
Run: `rm /Users/earchibald/work/gemini-superpowers/INSTALLATION_REPORT.md`

**Step 2: Commit**

```bash
git rm /Users/earchibald/work/gemini-superpowers/INSTALLATION_REPORT.md
git commit -m "chore: Remove INSTALLATION_REPORT.md for parity with vsc-superpowers"
```

---

### Task 2: Rename `LICENSE.md` to `LICENSE` in `gemini-superpowers`

**Files:**
- Rename: `/Users/earchibald/work/gemini-superpowers/LICENSE.md` to `/Users/earchibald/work/gemini-superpowers/LICENSE`

**Step 1: Rename `LICENSE.md` to `LICENSE`**

Command explanation: Renames the `LICENSE.md` file to `LICENSE` to match the naming convention in `vsc-superpowers`.
Run: `mv /Users/earchibald/work/gemini-superpowers/LICENSE.md /Users/earchibald/work/gemini-superpowers/LICENSE`

**Step 2: Commit**

```bash
git mv /Users/earchibald/work/gemini-superpowers/LICENSE.md /Users/earchibald/work/gemini-superpowers/LICENSE
git commit -m "chore: Rename LICENSE.md to LICENSE for parity with vsc-superpowers"
```