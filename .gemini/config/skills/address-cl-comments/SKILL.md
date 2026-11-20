---
name: address-cl-comments
description: >-
  Interactive comment-by-comment Gerrit CL remediation workflow. Fetches unresolved comments,
  locates the local commit by Change-Id, verifies each comment in a fresh unanchored code-reviewer
  subagent (two-sided falsification), and walks through each comment one at a time—amending the
  target commit (even mid-stack) or staging unpublished draft replies. Use when the user invokes
  /address-cl-comments or asks to address review comments on a Gerrit CL.
---

# Address-CL-Comments Workflow

Address unresolved Gerrit review comments one at a time after unanchored two-sided falsification in
a fresh `code-reviewer` subagent, either amending the target commit by `Change-Id` or staging an
unpublished draft reply.

Read before explaining findings, drafting replies, or editing commit messages:
- [core_philosophy.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/core_philosophy.md)
- [unified_review_rubrics.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/unified_review_rubrics.md)
- [writing_style.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/writing_style.md)

## Hard Rules

1. **One comment at a time:** Never bulk-fix comments up front. Walk through `Comment 1..N`
   sequentially with explicit user confirmation.
2. **Always amend the target commit by `Change-Id` (never leave standalone fix commits):** Never
   clobber `Change-Id:` footers or push patchsets unless asked. Re-resolve `TARGET_SHA` before each
   amend because rebasing rewrites SHAs:
   ```bash
   TARGET_SHA=$(git log --grep="^Change-Id: <CHANGE_ID>$" -n 1 --format="%H")
   # At HEAD:
   git commit -a --amend --no-edit   # or: git commit --amend --only -F <msg_file>
   # Mid-stack:
   git commit -a --fixup="$TARGET_SHA" && GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash "${TARGET_SHA}~1"
   # Mid-stack commit-message edit (preserving Change-Id):
   git commit --allow-empty --fixup=amend:"$TARGET_SHA" -F <msg_file> && GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash "${TARGET_SHA}~1"
   ```
3. **Stage unpublished drafts only — never publish:** Stage approved clarifying replies as drafts
   and **never** pass `--publish` or run `gerrit comments publish`:
   - **Gerrit CLI:** `/google/bin/releases/gemini-agents-gerrit/gerrit comments reply --host=<HOST> --change=<ID> --comment-id=<COMMENT_ID> --message="<reply>" --is-ai=false`
   - **Pigweed (`./gh`):** `./gh pr comment <id> --path <file> --line <line> -m "<reply>" --draft`
   - **Fuchsia (`fx gh`):** `fx gh pr comment <id> --patchset <N> --path <file> --line <line> -F <tmp_file> --draft` *(always match the reviewer comment's patchset `<N>`)*.

## 1. Locate Target CL, Local Commit, & Unresolved Comments

1. **Resolve CL, `Change-Id`, & `--host`:** Use the given CL URL/shortlink (`pwrev.dev/<id>`,
   `pwrev.dev/i/<id>`, `fxrev.dev/<id>`, `tqr/<id>`, `ag/<id>`) or inspect `HEAD` (`git log -n 1` +
   `git config --get remote.origin.url`). Query `./gh pr view <id>`, `fx gh pr view <id>`, or
   `gerrit info --host=<HOST> --change=<ID>` if needed to get `Change-Id: I...`.
2. **Locate local commit:** Run `git log --grep="^Change-Id: <CHANGE_ID>$" -n 1 --format="%H %s"`,
   check stack depth (`git rev-list --count "${TARGET_SHA}..HEAD"`), and verify `git status -s` is
   clean. If no local commit matches, stop and ask before checking out or cherry-picking.
3. **Fetch unresolved comments** ordered with `/COMMIT_MSG` first, then `file:line`:
   ```bash
   /google/bin/releases/gemini-agents-gerrit/gerrit comments list --host=<HOST> --change=<ID> --unresolved-only --googlers-only
   /google/bin/releases/gemini-agents-gerrit/gerrit conversations --host=<HOST> --change=<ID>
   ```
   *(Or `./gh pr view [<id>] --comments` in Pigweed / `fx gh pr view [<id>] --comments` in Fuchsia;
   consult [gerrit/SKILL.md](file:///google/src/files/head/depot/google3/learning/gemini/agents/skills/gerrit/SKILL.md)
   if needed.)* Stop and inform the user if zero unresolved comments exist.

## 2. Unanchored Falsification & Triage (`code-reviewer` Mode 3)

Do **not** evaluate reviewer comments in the Main Agent context (which may hold authoring bias from
earlier in the session):

1. Spawn a **fresh** [code-reviewer.md](file:///usr/local/google/home/fsareshwala/.gemini/config/agents/code-reviewer.md)
   (`TypeName: "code-reviewer"`, `Workspace: "inherit"`) in **Mode 3 (Reviewer-Comment
   Falsification)**.
2. Pass **only neutral facts**: `--host`, `--change`, repo root, `TARGET_SHA` (`git show --pretty=fuller "$TARGET_SHA"`),
   any commits above `TARGET_SHA` in the stack, and the raw unresolved comment threads (`1..N`).
   **Never** include prior Main Agent arguments or justifications for why the code was written that
   way.
3. Wait for its verified `Comment 1..N` triage report, then **kill the Mode 3 subagent**
   (`manage_subagents` `Action: "kill"`).

## 3. Comment-by-Comment Walkthrough (`k = 1..N`)

1. **Overview + Comment 1:** Show the target commit (`<short_sha> "<subject>"`, `Change-Id`, `HEAD`
   vs. `<M>` commits deep) and a numbered list (`1..N`) with clickable `file://` links, reviewer,
   verification verdict, action tag (`[Code Fix]`, `[Doc/Comment Update]`, `[Commit Msg]`, or
   `[Clarifying Reply]`), and coupled-comment notes. In the **same turn**, present **Comment 1 of
   N**.
2. **Present `Comment k of N` (re-checking if edits from `1..k-1` touched the same area) & Wait:**
   - Show clickable `[file:line](file:///...)` + `[PS<N>]`, quoted thread, Mode 3's
     **Verification** blurb (`Valid`, `Invalid / Trade-off`, or `Partially valid` with `file:line`
     proof), and recommended action.
   - **If Code / Doc / Commit-Msg Fix:** Describe exact edits (and coupled notes), include a concise
     `diff` preview if <= ~30 lines (summarize larger mechanical edits), and ask whether to
     **apply**, **stage a clarifying draft instead**, **modify**, or **skip**.
   - **If Clarifying Reply:** State why no code change is needed, show `> <proposed draft reply>`
     following [writing_style.md](file:///usr/local/google/home/fsareshwala/.gemini/config/references/writing_style.md),
     and ask whether to **stage draft**, **edit reply**, **make a code/doc change instead**, or
     **skip**.
   - **Stop and wait.**
3. **Execute ONLY `Comment k`:**
   - **Skip:** Immediately present `Comment k + 1`.
   - **Clarifying Reply:** Stage the unpublished draft reply (Rule 3), confirm, and in the **same
     turn** present `Comment k + 1`.
   - **Code / Doc / Commit-Msg Fix:** Read and edit strictly for `k`, run relevant builds and unit
     tests, show `git diff` + test results, and **pause for user approval** before amending. Once
     approved (applying any requested refinements first), re-resolve `TARGET_SHA` and amend the
     target commit (Rule 2), then in the **same turn** present `Comment k + 1`.

## 4. Final Summary

Report comments resolved via code/doc fixes (amended into `Change-Id: <CHANGE_ID>`), comments with
staged unpublished draft replies, skipped comments, and `git log --oneline -n <count>`.
