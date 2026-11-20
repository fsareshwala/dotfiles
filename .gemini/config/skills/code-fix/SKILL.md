---
name: code-fix
description: >-
  Audit local code, commits, or commit stacks via unanchored code-fix-reviewer discovery and
  challenger passes, run platform and sanitizer checks, fix verified issues interactively (or in
  batch when asked), and run a fresh final sign-off. Use when the user invokes /code-fix or asks to
  audit and fix local changes.
---

# Code-Fix Workflow

Audit local changes using separate discovery and adversarial-challenger `code-fix-reviewer`
subagents (eliminating both authoring and bug-hunter confirmation bias), verify builds and
sanitizers, fix material issues without complexity churn, and confirm readiness with a fresh
sign-off pass.

Read before explaining findings or editing commit messages:
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

## 1. Unanchored Audit & Challenger Passes (`code-fix-reviewer`)

1. **Gather neutral Git context:** Inspect `git status -s` or `git log --oneline <base>..HEAD`.
   Always pass `--pretty=fuller` to `git show` (bare `git show` respects user `format.pretty=oneline`
   and hides commit bodies and trailers).
2. **Mode 1 (Discovery):** Spawn [code-fix-reviewer.md](file:///usr/local/google/home/fsareshwala/.gemini/config/agents/code-fix-reviewer.md)
   (`TypeName: "code-fix-reviewer"`, `Workspace: "inherit"`) in **Mode 1**, passing **only factual
   scope** (target files, `--pretty=fuller` patches, and bug ID/objective—never include claims that
   the code is right or prior Main Agent design justifications). Audit a commit stack holistically
   rather than spawning one subagent per small commit. **Kill the Mode 1 subagent**
   (`manage_subagents` `Action: "kill"`) once its report arrives.
3. **Zero-findings fast path:** If Mode 1 returns `0` issues, run the verification matrix above; if
   clean, report `LGTM` and stop.
4. **Mode 2 (Adversarial Challenger):** Spawn a **fresh** `code-fix-reviewer` in **Mode 2**, passing
   *only* the target files/patches and Mode 1's candidate list (no Mode 1 investigation history, no
   Main Agent authoring history) to actively try to disprove each candidate. **Kill the Mode 2
   subagent** once its report arrives. If `0` issues survive, run the verification matrix and report
   `LGTM` (noting how many false positives were pruned).

## 2A. Interactive Mode (Default — One Issue at a Time)

Unless the user explicitly asked up front to fix everything in batch, walk through surviving
`Issue 1..N` one at a time in the Main Agent:

1. Show the numbered list (`1..N`) with clickable `file://` links, severity, root cause, and Mode
   2's **Verification** blurb (plus a 1-line note if Mode 2 pruned false positives), then present
   **Issue `k` of `N`** with a concise proposed fix and ask whether to **fix**, **modify**, or
   **skip** it. **Stop and wait.**
2. Edit in-tree files strictly for Issue `k`, run relevant builds/tests and formatter, and show
   `git diff` + test results.
3. Ask whether to **commit**, **amend** the target commit (preserving `Change-Id:` and
   `AuthorDate`), or **adjust**, following [writing_style.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/writing_style.md)
   for any commit message edits, then advance to `Issue k + 1`.

## 2B. Batch Mode (Only When User Explicitly Requests "Fix All")

1. **Fix verified issues pragmatically:** Fix all Mode-2-verified `Defect`, `Safety/UB`,
   build/presubmit/platform failures, core `Test Gap`s, and adjacent 1-line `Nit`s; skip any
   residual low-probability hardening that adds tracking flags/timers or combinatorial test bloat
   (noting skipped items in the final summary).
2. **Amend into target commits** preserving `AuthorDate`, `Bug:`/`Fixed:`, and `Change-Id:`
   (`git commit --fixup=<sha> && GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash --committer-date-is-author-date <base>`
   for mid-stack commits, or cherry-pick + `--amend --date="$AUTHOR_DATE"` when commits overlap).
   Format any updated commit messages per [writing_style.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/writing_style.md),
   then run the full verification matrix.

## 3. Mode 3 Unanchored Final Sign-Off & Cleanup

1. Export the final commit stack (`git show --pretty=fuller`) to the conversation `scratch/`
   directory and spawn a **fresh** `code-fix-reviewer` in **Mode 3**, passing only the final files
   and patches (no justifications).
2. Fix only genuine regressions or blocking defects (cap at **1** remediation pass; ignore nits),
   re-verify builds/tests, **kill all subagents**, and report fixed/pruned/skipped items plus
   `git log --oneline`.
