---
name: push
description: Automated Git commit and push workflow. Analyzes git status, dynamically groups changes into logical conventional commits with descriptive messages and bullets using LLM judgment, and pushes to remote. Use when the user runs /push or asks to commit and push changes.
---

# /push — Automated Git Commit & Push Protocol

When invoked via `/push` or when requested to commit and push changes, you execute a streamlined, intelligent git commit and push pipeline. You inspect the working directory, use your own judgment to group changed files into cohesive commit(s), author descriptive conventional commit messages, and push to the remote repository.

---

## 1. Core Principles & Invariants

1. **Dynamic Grouping by LLM Judgment:** Do not follow rigid category templates. Analyze the actual files changed right then and there. Use your own judgment to determine how changes relate and whether they should be grouped into a single commit or partitioned into multiple focused commits.
2. **Zero Test Execution Overhead:** You do NOT need to run UTs or test suites during `/push`. Focus entirely on inspecting git status, staging, authoring proper commit messages, and pushing.
3. **Atomic & Semantic Commits:** When changes span multiple unrelated tools, subsystems, or concerns, partition them into separate commits so history remains clean, readable, and bisectable.
4. **Conventional Commit Standard with Rich Descriptions:**
   - **Header:** `<type>(<scope>): <concise description in lowercase imperative mood>`
   - **Types:** `feat`, `fix`, `docs`, `test`, `refactor`, `style`, `chore`, `perf`.
   - **Body:** Comprehensive bullet points detailing:
     - What changed and why.
     - Specific functions, algorithms, constraints, or UI behaviors modified.
     - Handled edge cases or bug numbers resolved.
     - Files, tools, or documentation affected.
5. **Clean Remote Push:** Ensure git authentication (`gh auth status`) and remote tracking are aligned before pushing. Verify clean working tree after push.
6. **Bounded Execution Timeout:** All commands must execute with explicit timeouts to prevent hangs or blocking.

---

## 2. Step-by-Step Execution Workflow

### Step 1: Working Tree Inspection & Diff Analysis
1. Inspect current status:
   ```bash
   git status
   git diff --stat
   ```
2. Identify all modified files, deletions, and untracked files.
3. Verify remote repository and branch:
   ```bash
   git remote -v
   git branch --show-current
   ```
4. Verify GitHub authentication if necessary (`gh auth status`).

### Step 2: Dynamic Commit Partitioning (LLM Judgment)
Analyze the files changed right then and there:
- Assess the relationships between modified and untracked files based on what actually changed at that moment.
- Use your own judgment to determine whether to create 1 commit (if changes are cohesive or closely tied) or partition into multiple logical commits (if changes touch separate tools, shared utilities, or independent concerns).
- For each group, define a clear semantic scope, title, and descriptive bullet list.

### Step 3: Staging & Committing
For each logical group:
1. Stage strictly the files belonging to that group:
   ```bash
   git add <file1> <file2> ...
   ```
2. Verify staged items:
   ```bash
   git diff --cached --name-status
   ```
3. Commit with a structured header and descriptive bullet list:
   ```bash
   git commit -m "<type>(<scope>): <subject>" -m "- Bullet 1`n- Bullet 2`n- Bullet 3"
   ```
4. Repeat until `git status` reports working tree clean.

### Step 4: Push to Remote
1. Check upstream tracking:
   ```bash
   git fetch origin
   ```
2. Push commits to the active branch:
   ```bash
   git push origin <branch>
   ```

### Step 5: Post-Push Verification & Reporting
1. Confirm clean working tree:
   ```bash
   git status
   ```
2. Present a clear summary table to the user with:
   - Commit hash
   - Type & Scope
   - Title & key bullet highlights

