---
name: code-fix
description: >-
  Audit local code, commits, or commit stacks via code-fix-reviewer, run platform and sanitizer
  checks, fix material issues interactively (or in batch when asked), and run an unanchored final
  sign-off. Use when the user invokes /code-fix or asks to audit and fix local changes.
---

# Code-Fix Workflow

Audit local changes with the read-only `code-fix-reviewer` subagent, verify builds and sanitizers,
fix material issues without complexity churn, and confirm readiness with a fresh sign-off pass.

Read before auditing, explaining findings, or editing commit messages:
- [core_philosophy.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/core_philosophy.md)
- [unified_review_rubrics.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/unified_review_rubrics.md)
- [writing_style.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/writing_style.md)

## Verification Matrix

Run all applicable checks (one Bazel invocation at a time per workspace):
- **Pigweed (`bazelisk` + `./pw`):**
  - Host ASAN unit tests:
    `bazelisk test --noshow_progress --noshow_loading_progress --config=googletest --config=asan <targets>`
  - Fuchsia builds (mandatory when touching `pw_bluetooth_sapphire`, `#ifndef NINSPECT`, or
    `@platforms//os:fuchsia` targets):
    `bazelisk build --noshow_progress --noshow_loading_progress --config=fuchsia <targets>`
  - Standalone integration binaries when applicable (e.g., `bazelisk run //pw_ide/py:integration_test`).
  - Format & presubmit: `./pw --no-banner format --fix -b <base>` and
    `./pw --no-banner presubmit --step inclusive_language -b <base>`.
- **Fuchsia (`fx`):** `fx build`, `fx clippy`, `fx test`, and `fx format-code`.

## 1. Mode 1 Audit (`code-fix-reviewer`)

1. Inspect `git status -s` or `git log --oneline <base>..HEAD`. Always pass `--pretty=fuller` to
   `git show` when exporting patches (bare `git show` respects user `format.pretty=oneline` and
   hides commit bodies and trailers).
2. Spawn [code-fix-reviewer.md](file:///usr/local/google/home/fsareshwala/.gemini/config/agents/code-fix-reviewer.md)
   (`TypeName: "code-fix-reviewer"`, `Workspace: "inherit"`) in **Mode 1**, passing the target
   files/commits, `--pretty=fuller` patches, and any bug/user context. Audit a commit stack
   holistically (or by subsystem) rather than spawning one subagent per small commit.
3. **Kill the Mode 1 subagent** (`manage_subagents` `Action: "kill"`) once its report arrives so
   Mode 2 later runs unanchored.
4. **Zero-findings fast path:** If Mode 1 returns `0` issues, run the verification matrix above; if
   clean, report `LGTM` and stop.

## 2A. Interactive Mode (Default — One Issue at a Time)

Unless the user explicitly asked up front to fix everything in batch, walk through `Issue 1..N` one
at a time in the Main Agent:

1. Show the numbered list (`1..N`) with clickable `file://` links, severity, and root cause, then
   present **Issue `k` of `N`** with a concise proposed fix and ask whether to **fix**, **modify**,
   or **skip** it. **Stop and wait.**
2. Edit in-tree files strictly for Issue `k`, run relevant builds/tests and formatter, and show
   `git diff` + test results.
3. Ask whether to **commit**, **amend** the target commit (preserving `Change-Id:` and
   `AuthorDate`), or **adjust**, following [writing_style.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/writing_style.md)
   for any commit message edits, then advance to `Issue k + 1`.

## 2B. Batch Mode (Only When User Explicitly Requests "Fix All")

1. **Triage before editing:**
   - **Fix:** `Defect`, `Safety/UB`, build/presubmit/platform failures, core `Test Gap`s, and
     adjacent 1-line `Nit`s.
   - **Skip:** Low-probability 3rd-order state-machine hardening that adds tracking flags/timers or
     large combinatorial test matrices. Note skipped items in the final summary.
2. **Amend into target commits** preserving `AuthorDate`, `Bug:`/`Fixed:`, and `Change-Id:`
   (`git commit --fixup=<sha> && GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash --committer-date-is-author-date <base>`
   for mid-stack commits, or cherry-pick + `--amend --date="$AUTHOR_DATE"` when commits overlap).
   Format any updated commit messages per [writing_style.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/writing_style.md),
   then run the full verification matrix.

## 3. Mode 2 Unanchored Sign-Off & Cleanup

1. Export the final commit stack (`git show --pretty=fuller`) to the conversation `scratch/`
   directory and spawn a **fresh** `code-fix-reviewer` in **Mode 2**.
2. Fix only genuine regressions or blocking defects (cap at **1** remediation pass; ignore nits),
   re-verify builds/tests, and **kill all subagents** (`manage_subagents`).
3. Report fixed (and any intentionally skipped) items plus `git log --oneline`.
