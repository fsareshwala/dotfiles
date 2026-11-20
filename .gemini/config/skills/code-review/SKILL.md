---
name: code-review
description: >-
  Read-only code review workflow for Gerrit CLs and local Git diffs. Runs separate discovery and
  adversarial-challenger passes via code-reviewer, stages verified findings as unpublished
  peer-voice Gerrit drafts (--is-ai=false), and handles follow-up Q&A or draft edits. Use when the
  user invokes /code-review or asks to review a CL, patch, or someone else's code.
---

# Code-Review Workflow

Review Gerrit CLs (typically others' CLs) or local diffs using separate discovery and
adversarial-challenger `code-reviewer` passes so false positives are pruned before staging
unpublished peer-voice drafts on Gerrit.

Read before explaining findings or editing drafts:
- [core_philosophy.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/core_philosophy.md)
- [unified_review_rubrics.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/unified_review_rubrics.md)
- [writing_style.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/writing_style.md)

## Safety & Draft Rules

1. **Never mutate local workspaces:** Never run `git checkout`, `./gh pr checkout`,
   `fx gh pr checkout`, `git reset`, or edit source files—attached workspaces hold the user's own
   work.
2. **Stage unpublished peer-voice drafts only:** Always pass `--is-ai=false` (prefixing minor
   suggestions with `nit: `). **Never** run `gerrit comments publish`, `gerrit vote`,
   `./gh pr review --publish`, or `fx gh pr review` unless the user explicitly asks in a follow-up.

## 1. Resolve Target

Extract `--host`, `--change`, and optional `--revision=<PS>` from the prompt or active Gerrit URL:
- Full URL `https://<host>/c/<project>/+/<num>[/<ps>]` -> `--host=https://<host>`, `--change=<num>`
- `pwrev.dev/<num>` or `pwrev/<num>` -> `https://pigweed-review.googlesource.com`
- `pwrev.dev/i/<num>` -> `https://pigweed-internal-review.git.corp.google.com`
- `fxrev.dev/<num>` or `fxr/<num>` -> `https://fuchsia-review.googlesource.com`
- `tqr/<num>`, `fxrev.dev/i/<num>`, or `fxr/i/<num>` ->
  `https://turquoise-internal-review.git.corp.google.com`
- `aosp/<num>` -> `https://android-review.googlesource.com`
- `ag/<num>` -> `https://googleplex-android-review.googlesource.com`
- `crrev.com/c/<num>` -> `https://chromium-review.googlesource.com`
- `crrev.com/i/<num>` -> `https://chrome-internal-review.googlesource.com`

For a **local** uncommitted diff or unpushed commit with no Gerrit CL, inspect `git status -s` /
`git log -n 1` and run in **Local Review Mode** (skipping Step 3). Ask the user if the target is
ambiguous.

## 2. Unanchored Discovery & Challenger Passes (`code-reviewer`)

1. **Mode 1 (Discovery):** Spawn [code-reviewer.md](file:///usr/local/google/home/fsareshwala/.gemini/config/agents/code-reviewer.md)
   (`TypeName: "code-reviewer"`, `Workspace: "inherit"`) in **Mode 1**, passing neutral target info
   (`Host`, `Change`, `Revision`, active local workspaces for read-only caller/sibling lookups, and
   any user focus notes). **Kill the Mode 1 subagent** (`manage_subagents` `Action: "kill"`) once
   its report arrives. If Mode 1 returns `0` findings, skip to Step 4 (`LGTM`).
2. **Mode 2 (Adversarial Challenger):** Spawn a **fresh** `code-reviewer` in **Mode 2**, passing
   *only* the target coordinates and Mode 1's candidate findings (no Mode 1 reasoning history). It
   actively attempts to disprove each candidate against full post-change files and callers, drops
   false positives, verifies 1-indexed new-side line numbers, and adds a **Verification** blurb to
   each survivor. **Kill the Mode 2 subagent** once its report arrives.

## 3. Stage Unpublished Gerrit Drafts (Gerrit CLs Only)

1. **`0` surviving findings (`LGTM`):** Stage nothing and proceed to Step 4.
2. **`1..N` verified findings:** Stage each surviving finding on `--revision="<PS>"` (use
   `--line=<L>` for a single line or `/COMMIT_MSG`, or `--start-line=<S> --end-line=<E>` for a
   range):
   ```bash
   /google/bin/releases/gemini-agents-gerrit/gerrit comments post \
     --host="<HOST>" --change="<CHANGE>" --revision="<PS>" \
     --file="<FILE_OR_/COMMIT_MSG>" --line=<LINE> \
     --is-ai=false --unresolved=true --message="<DRAFT_MESSAGE>"
   ```
   *(Pigweed auth fallback: `~/code/pigweed/gh pr comment <ID> --path "<FILE>" --line <END_LINE> -m "<DRAFT_MESSAGE>" --draft`.)*
3. Run `gerrit comments list --host="<HOST>" --change="<CHANGE>" --drafts` once to confirm drafts
   landed and capture each `comment-id` for follow-up edits.

## 4. Present Summary & Handle Follow-Ups

1. **Chat summary:** State CL title/link, `PS<N>`, **Verdict** (`LGTM`, `LGTM with nits`, or
   `Needs changes`), and confirm **`N` unpublished drafts are staged** (nothing published). For each
   finding `k`, show `[<Severity> | <Category>] <file>:<line>` (clickable `file://` only for local
   reviews) — **`<Title>`**, a 1–2 sentence explanation + Mode 2's **Verification** blurb, and
   `> <staged draft>`. Note any candidates Mode 2 disproved or skipped duplicate threads in one line
   at the end (write a full Markdown artifact only if `> 8` findings).
2. **Follow-ups:** Answer codebase/CL questions directly via `gerrit cat` or `read_file`. Edit or
   delete specific drafts on request via:
   ```bash
   /google/bin/releases/gemini-agents-gerrit/gerrit comments update|delete \
     --host="<HOST>" --change="<CHANGE>" --comment-id="<DRAFT_ID>" [--message="<NEW_TEXT>"]
   ```
