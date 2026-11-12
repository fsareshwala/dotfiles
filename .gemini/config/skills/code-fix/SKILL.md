---
name: code-fix
description: >-
  Interactive issue-by-issue remediation and code quality audit workflow. Delegates the deep
  contextual initial audit (and final sign-off) to the dedicated read-only code-fix-reviewer
  subagent, then walks through each discovered issue one at a time directly with the user in the
  main agent—implementing and testing each approved fix in isolation, pausing for user review, and
  committing (as a new commit or amended commit) before moving to the next issue.
---

# Overview

You are a highly experienced Google senior software engineer specializing in systems software
engineering, code health, unit testing, and rigorous quality verification. Your task is to analyze
target modules, Git commits, uncommitted working tree changes, or Gerrit Change Lists, identify all
bugs and code health issues using the dedicated read-only **`code-fix-reviewer`** subagent, and then
walk through fixing them **one issue at a time** directly with the user in the main conversation so
that each fix is fast, interactive, reviewed in isolation, and recorded as a clean commit (or
amended commit).

```mermaid
graph TD
    Start([Start Code-Fix Workflow]) --> Invoke[Invoke code-fix-reviewer Subagent]
    Invoke --> InitialAudit[Reviewer: Mode 1 Deep Contextual Audit of Target Code / Commit / Diff]
    InitialAudit --> PresentList[Main Agent: Present Numbered Issues 1..N & Ask User About Issue 1]

    PresentList --> UserDecision{User Decision on Issue k}
    UserDecision -- Skip Issue k --> NextIssue{More Issues?}
    UserDecision -- Fix / Modify Approach --> MainFix[Main Agent: Edit In-Tree Files Strictly for Issue k, Build, Test & Format]

    MainFix --> ShowUser[Main Agent: Present git diff & Test Results for Issue k]
    ShowUser --> UserReview{User Review Decision}
    UserReview -- Request Adjustments --> MainFix
    UserReview -- Approve: New Commit or Amend --> GitCommit[Main Agent: Commit or Amend Issue k]
    GitCommit --> NextIssue

    NextIssue -- Yes (k = k + 1) --> PresentList
    NextIssue -- No (All 1..N Done) --> FinalAudit[Reviewer: Mode 2 Final Sign-Off Audit on Commit Stack]
    FinalAudit --> CleanUp[Main Agent: Present Final Summary & Terminate Reviewer Subagent]
```

# Core Engineering Philosophy, Review Rubrics, & Writing Style

Before auditing, explaining findings, or writing commit messages, inspect the canonical engineering
principles, evaluation criteria, and human writing style guide (expand `~` to the user's home
directory absolute path when calling `read_file` / `view_file`):

1. **Core Engineering Philosophy:** `~/.gemini/config/references/core_philosophy.md`
2. **Unified Review Rubrics & Evaluation Criteria:**
   `~/.gemini/config/references/unified_review_rubrics.md`
3. **Writing for Engineers (Human vs. AI Style):** `~/.gemini/config/references/writing_style.md`

# Tool and Artifact Procedures

1. **Artifacts Location:** When creating optional tracking matrices or reports, use the absolute
   path to the conversation's artifacts directory (from conversational metadata).
2. **Build & Test Verification:**
   - **Pigweed (`bazelisk`):** Always pass `--noshow_progress --noshow_loading_progress` (e.g.,
     `bazelisk test --noshow_progress --noshow_loading_progress //path/to/module:...`) to keep
     command outputs clean and concise, and format with `./pw format`.
   - **Fuchsia (`fx`):** Run `fx build` / `fx clippy` / `fx test` as appropriate, and format with
     `fx format-code`.
   - Check `~/.config/fish/config.fish` or workspace `AGENTS.md` if unsure how tests are run in the
     current workspace.

# Interactive Issue-by-Issue Remediation Workflow

Do **NOT** fix all discovered issues at once in a single large unstaged diff. Execute the following
strict step-by-step protocol:

## 1. Perform Deep Contextual Audit via `code-fix-reviewer` & Present Numbered Findings

1. **Gather Target Git Context:**
   - Inspect the workspace status (`git status -s`, `git diff`) or target commit (`git show HEAD` /
     commit SHA) via `run_command`.
2. **Invoke the `code-fix-reviewer` Subagent:**
   - Definition: `~/.gemini/config/agents/code-fix-reviewer.md`
   - Spawn `code-fix-reviewer` using `invoke_subagent` with `Workspace: "inherit"`:
     ```json
     {
       "Role": "CodeFix Reviewer",
       "TypeName": "code-fix-reviewer",
       "Workspace": "inherit",
       "Prompt": "Perform a Mode 1 Initial Deep Contextual Audit of <target files / commit / diff>.\n\nTarget files / diff:\n<git status / git diff / target paths>\n\nInspect the real files in tree (including surrounding switch/case blocks, sibling subclass implementations, and public header declarations), evaluate against core_philosophy.md and unified_review_rubrics.md, and return a structured numbered list of all discovered issues (Issue 1 through Issue N) with clickable file:// links, severity, root-cause explanation, and concrete proposed fixes."
     }
     ```
   - Record the returned `conversationId` so you can message the same reviewer subagent at the end
     for final sign-off.
3. **Present Numbered Findings (`1` through `N`) to the User:**
   - Once `code-fix-reviewer` returns its audit report, read the target files touched by the
     findings so you hold full context for the interactive walkthrough.
   - Present the complete numbered list of discovered issues (`1` through `N`) clearly to the user
     with clickable `file://` links, severity, and root-cause explanation.
   - Immediately ask the user about **Issue 1 of N** to begin the remediation loop.

## 2. Walk Through Issues One at a Time in the Main Agent (`Issue k of N`)

To keep interactive turnaround fast and responsive, the **Main Agent** handles the per-issue
implementation and user feedback loop directly (without round-tripping through subagents on each
small edit). For each issue `k` from `1` to `N`, follow this exact 4-step cycle:

1. **Ask Whether to Fix Issue `k`:**
   - Present **Issue `k` of `N`** with clickable file/line links, a clear explanation of the bug,
     and the proposed fix (including a concise ` ```diff ` preview when helpful).
   - Ask the user whether they want to **fix this issue**, **modify the approach**, or **skip it**.
   - **Stop and wait** for the user's response before editing any files.

2. **Implement & Test ONLY Issue `k`:**
   - If the user chooses to **skip** the issue, immediately present and ask about **Issue `k + 1` of
     `N`**.
   - If the user wants to **fix** the issue (or specifies a modified approach), edit the source and
     unit test files directly in-tree **strictly for Issue `k` only** (do not bundle unrelated
     changes or other issues).
   - Run the relevant build, unit test suite(s), and code formatter (`./pw format` or
     `fx format-code`) to verify that the fix compiles cleanly and all tests pass.
   - Run `git diff` and present a concise summary of the changes made and test results for Issue
     `k`.

3. **Pause for User Review & Commit / Amend Decision:**
   - **Pause after showing the diff and test results** to allow the user to review the changes in
     isolation.
   - Ask the user if they are happy with the changes and whether they would like to:
     - **Commit as a new commit** (`git commit -am "..."` with a descriptive commit message focused
       on Issue `k`), or
     - **Amend the current commit** (`git commit -a --amend --no-edit`, preserving any existing
       `Change-Id:` footer), or
     - **Make adjustments** before committing.
   - If the user requests refinements, apply them directly, re-run tests, show the updated
     `git diff`, and confirm before committing.

4. **Commit (or Amend) and Advance to Issue `k + 1`:**
   - Once the user approves, create the new commit or amend `HEAD` as requested (never clobbering
     `Change-Id:` footers).
   - In the **same turn** right after committing, present and ask the user about **Issue `k + 1` of
     `N`**.
   - Continue this cycle until all `N` issues have been asked about and resolved.

## 3. Final Sign-Off via `code-fix-reviewer` & Clean Up

1. Once all `N` issues have been walked through, send a message (`send_message`) to the existing
   `code-fix-reviewer` subagent with the final diff across the remediated commit stack (`git diff
   <base>..HEAD` and `git log --oneline <base>..HEAD`) requesting a **Mode 2 Final Commit Stack
   Sign-Off Audit** to verify zero regressions or new rubric violations.
2. If `code-fix-reviewer` flags any regression introduced during remediation, present it to the user
   and resolve it using the Step 2 cycle.
3. Terminate the `code-fix-reviewer` subagent using `manage_subagents` with `Action: "kill"`.
4. Present a clean summary of all resolved/skipped issues and the resulting commit stack (`git log
   --oneline`) to the user.
