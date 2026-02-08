# Repository Parity and README Merge

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Bring `gemini-superpowers` to full parity with the core `superpowers` repository (from `.cache/superpowers`) and consolidate `docs/README.md` content into the root `README.md` for `gemini-superpowers`. For `vsc-superpowers`, ensure its root `README.md` is self-contained.

**Architecture:** The plan involves reading existing README files, modifying them by appending content, deleting redundant files, and copying missing files and directories from the reference `superpowers` cache and `vsc-superpowers` repository to the `gemini-superpowers` repository.

**Tech Stack:** `bash` commands (for file operations like `cp`, `rm`, `rsync`), `git` (for commits).

---

### Task 1: Merge `docs/README.md` into `README.md` for `gemini-superpowers`

**Files:**
- Modify: `/Users/earchibald/work/gemini-superpowers/README.md`
- Delete: `/Users/earchibald/work/gemini-superpowers/docs/README.md`

**Step 1: Read the content of `gemini-superpowers/docs/README.md`**

Run: `read_file(file_path='/Users/earchibald/work/gemini-superpowers/docs/README.md')`

Expected: Content of the file. This content will be stored temporarily to be appended.

**Step 2: Remove the link to `docs/README.md` from `gemini-superpowers/README.md`**

Instruction: Remove the line that links to `docs/README.md` as the full documentation.
Old String:
```
## Documentation

For a comprehensive overview, detailed command references, and insights into the Gemini-specific cost model, please refer to our [full documentation](./docs/README.md).
```

New String:
```
## Documentation
```

Run: `replace(file_path='/Users/earchibald/work/gemini-superpowers/README.md', old_string='''## Documentation

For a comprehensive overview, detailed command references, and insights into the Gemini-specific cost model, please refer to our [full documentation](./docs/README.md).''', new_string='''## Documentation''', instruction='Remove the explicit link to the documentation in `docs/README.md` because its content will be merged into the root `README.md`.')`

**Step 3: Append the content of `gemini-superpowers/docs/README.md` to `gemini-superpowers/README.md`**

Instruction: Append the content fetched in Step 1 to the end of `/Users/earchibald/work/gemini-superpowers/README.md`.

*(The actual `write_file` command for appending will be generated during execution, using the content from Step 1.)*

**Step 4: Delete `gemini-superpowers/docs/README.md`**

Command explanation: Deletes the `docs/README.md` file from `gemini-superpowers` as its content has been merged.
Run: `rm /Users/earchibald/work/gemini-superpowers/docs/README.md`

**Step 5: Commit**

```bash
git add /Users/earchibald/work/gemini-superpowers/README.md
git rm /Users/earchibald/work/gemini-superpowers/docs/README.md
git commit -m "docs: merge docs/README.md into root README.md for gemini-superpowers"
```

---

### Task 2: Verify `vsc-superpowers` `docs/README.md` state

**Files:**
- Check: `/Users/earchibald/work/vsc-superpowers/docs/README.md`

**Step 1: Check for existence of `vsc-superpowers/docs/README.md`**

Run: `list_directory(dir_path='/Users/earchibald/work/vsc-superpowers/docs')`

Expected: The output should NOT list `README.md`. If it is listed, then a merge operation similar to Task 1 would be performed (though this is not expected).

**Step 2: Commit**

No files are changed in this task; therefore, no commit is needed for this specific step. The verification confirms the current state.

---

### Task 3: Bring `gemini-superpowers` to parity with `.cache/superpowers` - Core files

**Files:**
- Create: `/Users/earchibald/work/gemini-superpowers/.gitattributes`
- Create: `/Users/earchibald/work/gemini-superpowers/RELEASE-NOTES.md`

**Step 1: Copy `.gitattributes`**

Command explanation: Reads the content of `.gitattributes` from the cache and writes it to the `gemini-superpowers` repository.
Run: `cp /Users/earchibald/.cache/superpowers/.gitattributes /Users/earchibald/work/gemini-superpowers/.gitattributes`

**Step 2: Copy `RELEASE-NOTES.md`**

Command explanation: Reads the content of `RELEASE-NOTES.md` from the cache and writes it to the `gemini-superpowers` repository.
Run: `cp /Users/earchibald/.cache/superpowers/RELEASE-NOTES.md /Users/earchibald/work/gemini-superpowers/RELEASE-NOTES.md`

**Step 3: Commit**

```bash
git add /Users/earchibald/work/gemini-superpowers/.gitattributes /Users/earchibald/work/gemini-superpowers/RELEASE-NOTES.md
git commit -m "feat: add .gitattributes and RELEASE-NOTES.md from core superpowers"
```

---

### Task 4: Bring `gemini-superpowers` to parity with `.cache/superpowers` - Plugin/Tool directories

**Files:**
- Create: `/Users/earchibald/work/gemini-superpowers/.claude-plugin/...`
- Create: `/Users/earchibald/work/gemini-superpowers/.codex/...`
- Modify: `/Users/earchibald/work/gemini-superpowers/.github/FUNDING.yml` (create if not exists, add content)
- Create: `/Users/earchibald/work/gemini-superpowers/.opencode/...`
- Create: `/Users/earchibald/work/gemini-superpowers/agents/...`
- Create: `/Users/earchibald/work/gemini-superpowers/commands/...`
- Create: `/Users/earchibald/work/gemini-superpowers/hooks/...`
- Create: `/Users/earchibald/work/gemini-superpowers/lib/...`

**Step 1: Copy `.claude-plugin/` directory**

Command explanation: Copies the `.claude-plugin` directory and its contents recursively from the cache to `gemini-superpowers`.
Run: `run_shell_command(command='rsync -a /Users/earchibald/.cache/superpowers/.claude-plugin/ /Users/earchibald/work/gemini-superpowers/.claude-plugin/', description='Copy .claude-plugin directory recursively.')`

**Step 2: Copy `.codex/` directory**

Command explanation: Copies the `.codex` directory and its contents recursively from the cache to `gemini-superpowers`.
Run: `run_shell_command(command='rsync -a /Users/earchibald/.cache/superpowers/.codex/ /Users/earchibald/work/gemini-superpowers/.codex/', description='Copy .codex directory recursively.')`

**Step 3: Copy `FUNDING.yml` to `.github/`**

Command explanation: Copies `FUNDING.yml` from the cache to the `.github/` directory in `gemini-superpowers`.
Run: `run_shell_command(command='cp /Users/earchibald/.cache/superpowers/.github/FUNDING.yml /Users/earchibald/work/gemini-superpowers/.github/FUNDING.yml', description='Copy FUNDING.yml to .github directory.')`

**Step 4: Copy `.opencode/` directory**

Command explanation: Copies the `.opencode` directory and its contents recursively from the cache to `gemini-superpowers`.
Run: `run_shell_command(command='rsync -a /Users/earchibald/.cache/superpowers/.opencode/ /Users/earchibald/work/gemini-superpowers/.opencode/', description='Copy .opencode directory recursively.')`

**Step 5: Copy `agents/` directory**

Command explanation: Copies the `agents` directory and its contents recursively from the cache to `gemini-superpowers`.
Run: `run_shell_command(command='rsync -a /Users/earchibald/.cache/superpowers/agents/ /Users/earchibald/work/gemini-superpowers/agents/', description='Copy agents directory recursively.')`

**Step 6: Copy `commands/` directory**

Command explanation: Copies the `commands` directory and its contents recursively from the cache to `gemini-superpowers`.
Run: `run_shell_command(command='rsync -a /Users/earchibald/.cache/superpowers/commands/ /Users/earchibald/work/gemini-superpowers/commands/', description='Copy commands directory recursively.')`

**Step 7: Copy `hooks/` directory**

Command explanation: Copies the `hooks` directory and its contents recursively from the cache to `gemini-superpowers`.
Run: `run_shell_command(command='rsync -a /Users/earchibald/.cache/superpowers/hooks/ /Users/earchibald/work/gemini-superpowers/hooks/', description='Copy hooks directory recursively.')`

**Step 8: Copy `lib/` directory**

Command explanation: Copies the `lib` directory and its contents recursively from the cache to `gemini-superpowers`.
Run: `run_shell_command(command='rsync -a /Users/earchibald/.cache/superpowers/lib/ /Users/earchibald/work/gemini-superpowers/lib/', description='Copy lib directory recursively.')`

**Step 9: Commit**

```bash
git add /Users/earchibald/work/gemini-superpowers/.claude-plugin /Users/earchibald/work/gemini-superpowers/.codex /Users/earchibald/work/gemini-superpowers/.github/FUNDING.yml /Users/earchibald/work/gemini-superpowers/.opencode /Users/earchibald/work/gemini-superpowers/agents /Users/earchibald/work/gemini-superpowers/commands /Users/earchibald/work/gemini-superpowers/hooks /Users/earchibald/work/gemini-superpowers/lib
git commit -m "feat: add plugin/tool related directories and FUNDING.yml from core superpowers"
```

---

### Task 5: Bring `gemini-superpowers` to parity with `.cache/superpowers` - Docs & Tests

**Files:**
- Create: `/Users/earchibald/work/gemini-superpowers/docs/README.codex.md`
- Create: `/Users/earchibald/work/gemini-superpowers/docs/README.opencode.md`
- Create: `/Users/earchibald/work/gemini-superpowers/docs/testing.md`
- Create: `/Users/earchibald/work/gemini-superpowers/tests/...` (entire directory)

**Step 1: Copy `docs/README.codex.md`**

Command explanation: Copies `README.codex.md` from the cache to `gemini-superpowers/docs/`.
Run: `run_shell_command(command='cp /Users/earchibald/.cache/superpowers/docs/README.codex.md /Users/earchibald/work/gemini-superpowers/docs/README.codex.md', description='Copy README.codex.md to gemini-superpowers/docs.')`

**Step 2: Copy `docs/README.opencode.md`**

Command explanation: Copies `README.opencode.md` from the cache to `gemini-superpowers/docs/`.
Run: `run_shell_command(command='cp /Users/earchibald/.cache/superpowers/docs/README.opencode.md /Users/earchibald/work/gemini-superpowers/docs/README.opencode.md', description='Copy README.opencode.md to gemini-superpowers/docs.')`

**Step 3: Copy `docs/testing.md`**

Command explanation: Copies `testing.md` from the cache to `gemini-superpowers/docs/`.
Run: `run_shell_command(command='cp /Users/earchibald/.cache/superpowers/docs/testing.md /Users/earchibald/work/gemini-superpowers/docs/testing.md', description='Copy testing.md to gemini-superpowers/docs.')`

**Step 4: Copy `tests/` directory**

Command explanation: Copies the `tests` directory and its contents recursively from the cache to `gemini-superpowers`.
Run: `run_shell_command(command='rsync -a /Users/earchibald/.cache/superpowers/tests/ /Users/earchibald/work/gemini-superpowers/tests/', description='Copy tests directory recursively.')`

**Step 5: Commit**

```bash
git add /Users/earchibald/work/gemini-superpowers/docs/README.codex.md /Users/earchibald/work/gemini-superpowers/docs/README.opencode.md /Users/earchibald/work/gemini-superpowers/docs/testing.md /Users/earchibald/work/gemini-superpowers/tests
git commit -m "feat: add docs and tests directories from core superpowers"
```

---

### Task 6: Bring `gemini-superpowers` to parity with `vsc-superpowers` - `docs/SKILLS_REFERENCE.md` and `docs/images/`

**Files:**
- Create: `/Users/earchibald/work/gemini-superpowers/docs/SKILLS_REFERENCE.md`
- Create: `/Users/earchibald/work/gemini-superpowers/docs/images/...`

**Step 1: Copy `docs/SKILLS_REFERENCE.md`**

Command explanation: Copies `SKILLS_REFERENCE.md` from `vsc-superpowers/docs/` to `gemini-superpowers/docs/`.
Run: `run_shell_command(command='cp /Users/earchibald/work/vsc-superpowers/docs/SKILLS_REFERENCE.md /Users/earchibald/work/gemini-superpowers/docs/SKILLS_REFERENCE.md', description='Copy SKILLS_REFERENCE.md to gemini-superpowers/docs.')`

**Step 2: Copy `docs/images/` directory**

Command explanation: Copies the `images` directory and its contents recursively from `vsc-superpowers/docs/` to `gemini-superpowers/docs/`.
Run: `run_shell_command(command='rsync -a /Users/earchibald/work/vsc-superpowers/docs/images/ /Users/earchibald/work/gemini-superpowers/docs/images/', description='Copy images directory recursively.')`

**Step 3: Commit**

```bash
git add /Users/earchibald/work/gemini-superpowers/docs/SKILLS_REFERENCE.md /Users/earchibald/work/gemini-superpowers/docs/images
git commit -m "feat: add SKILLS_REFERENCE.md and images to docs from vsc-superpowers"
```