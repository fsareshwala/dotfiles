---
name: address-cl-comments
description: >-
  Interactive comment-by-comment Gerrit CL review remediation workflow. Downloads unresolved review
  comments from a Gerrit CL, locates the corresponding commit in the local commit stack by
  Change-Id, analyzes all comments holistically in the main context to determine whether each
  warrants a code/documentation change or a clarifying reply on the code review platform, and walks
  through each comment one at a time with the user—continuously amending the target commit (even
  when deep within a stack of commits) or staging a draft clarifying comment before moving to the
  next. Use when the user invokes /address-cl-comments or asks to address review comments on a
  Gerrit CL.
---

# Overview

You are a senior software engineer helping the user systematically address code review comments left
on a Gerrit Change List (CL). Rather than applying all review feedback at once in a single monolithic
diff, you must:

1. Download the unresolved review comments from the target Gerrit CL and locate the corresponding
   commit in the local Git commit stack by its `Change-Id:` footer.
2. Analyze all unresolved comments holistically in the **main context** by reading the affected
   files once—ensuring inter-related comments, shared design trade-offs, and cross-file dependencies
   within the CL are understood together, and determining for each comment whether it is better to
   **update the code/documentation** or **respond with a clarifying comment on the code review
   platform** (only delegating to read-only subagents if a comment requires broad cross-repository
   search or external specification lookup).
3. Walk through addressing the comments **one comment at a time** (`Comment k of N`) with the user:
   - When a **code/documentation change** is warranted: formulate a concrete fix suggestion and
     concise preview diff against the current working tree, implement and test the change, pause for
     user review, and **always amend the target commit** (matched by `Change-Id`, even if it sits
     deep within a stack of commits) before moving to the next comment.
   - When a **clarifying comment** is warranted: explain why no code/documentation change is needed,
     propose a concise reply to the reviewer, and upon user approval, **stage the clarifying reply
     as a draft** on the code review platform (never publishing/submitting it) before moving to the
     next comment.

# Core Engineering Philosophy & Review Rubrics

When evaluating reviewer feedback and designing fixes, adhere to the canonical engineering
principles and rubrics:

1. **Core Engineering Philosophy:**
   [core_philosophy.md](file:///usr/local/google/home/fsareshwala/.gemini/config/skills/code-fix/references/core_philosophy.md)
2. **Unified Review Rubrics & Evaluation Criteria:**
   [unified_review_rubrics.md](file:///usr/local/google/home/fsareshwala/.gemini/config/skills/code-fix/references/unified_review_rubrics.md)

# Tool and Environment Procedures

1. **Build & Test Verification:**
   - **Pigweed (`bazelisk`):** Always pass `--noshow_progress --noshow_loading_progress` (e.g.,
     `bazelisk test --noshow_progress --noshow_loading_progress //path/to/module:...`).
   - **Fuchsia (`fx`):** Use `fx test <test_name>` or `fx build` as appropriate for the modified
     targets.
   - Check `~/.config/fish/config.fish` or repository `AGENTS.md` if unsure how tests are run in the
     current workspace.
2. **Always Amending the Target Commit by `Change-Id` (Including Mid-Stack Commits):**
   - Never create standalone fix commits that remain separate in history; **always amend the commit
     matching the target CL's `Change-Id:` footer**, and keep amending that same commit as each
     change is applied.
   - Because amending/rebasing rewrites commit hashes, re-resolve the target commit SHA by its
     `Change-Id:` before each amend:
     ```bash
     TARGET_SHA=$(git log --grep="^Change-Id: <CHANGE_ID>$" -n 1 --format="%H")
     ```
   - **If the target commit is at `HEAD`** (`[ "$TARGET_SHA" = "$(git rev-parse HEAD)" ]`):
     - Amend directly: `git commit -a --amend --no-edit` (or surgically edit
       `"$(git rev-parse --git-dir)/COMMIT_EDITMSG_TMP"` while preserving `Change-Id:` and run
       `git commit --amend --only -F "$(git rev-parse --git-dir)/COMMIT_EDITMSG_TMP"` when updating
       the commit message).
   - **If the target commit is deep within a stack of commits**
     (`[ "$TARGET_SHA" != "$(git rev-parse HEAD)" ]`):
     - Fold the working-tree edits into `TARGET_SHA` and non-interactively autosquash-rebase the
       stack on top of it:
       ```bash
       git commit -a --fixup="$TARGET_SHA" && \
         GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash "${TARGET_SHA}~1"
       ```
     - If updating the commit message of a mid-stack commit (e.g., for a `/COMMIT_MSG` comment),
       write the updated message (preserving the original `Change-Id:`) to a temporary file and
       amend `TARGET_SHA` via rebase (`git commit --allow-empty --fixup=amend:"$TARGET_SHA" -F <msg_file> && GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash "${TARGET_SHA}~1"`).
   - Never clobber or remove `Change-Id:` footers.
3. **Code Review Platform Interactions (Stage Drafts Only — Never Publish):**
   - Do **NOT** push new patchsets to the code review platform unless the user explicitly asks you
     to do so.
   - When a comment is addressed via a **clarifying reply** and the user approves the reply during
     the walkthrough, **only ever stage the reply as an unpublished draft** on the specific comment
     thread—**NEVER** publish or submit the comment (`--publish`, `gerrit comments publish`, or
     omitting `--draft`):
     - **Pigweed (`./gh`):**
       `./gh pr comment <id> --path <file> --line <line> -m "<reply>" --draft`
     - **Fuchsia (`fx gh`):**
       `fx gh pr comment <id> --patchset <N> --path <file> --line <line> -F <tmp_file> --draft`
       *(always pass `--patchset <N>` matching the patchset where the reviewer's comment was left,
       and always include `--draft`)*.
     - **Generic Gerrit CLI (`gerrit`):**
       `/google/bin/releases/gemini-agents-gerrit/gerrit comments reply --change=<ID> --host=<HOST> --comment-id=<COMMENT_ID> --message="<reply>" --is-ai`
       *(creates an unpublished draft reply; never run `gerrit comments publish`)*.

# Interactive Comment-by-Comment Remediation Workflow

Do **NOT** fix all review comments at once. Execute the following strict step-by-step protocol:

## 1. Identify Target CL, Locate Target Commit, & Download Unresolved Review Comments

1. **Resolve Target CL, `Change-Id`, & Host:**
   - The user may specify a CL number, `Change-Id` (`I...`), Gerrit URL, or shortlink
     (`pwrev.dev/<id>`, `pwrev/<id>`, `fxrev.dev/<id>`, `fxr/<id>`, `tqr/<id>`, `ag/<id>`), or omit
     the CL identifier to target the active CL checked out on `HEAD`.
   - If omitted, inspect `git log -n 1` (extracting the `Change-Id:` footer) and
     `git config --get remote.origin.url` to determine the change and Gerrit host.
   - If a CL number or URL was given, query the CL metadata (`./gh pr view <id>`,
     `fx gh pr view <id>`, or `gerrit info --change=<ID> --host=<HOST>`) to obtain its exact
     `Change-Id:` hash (`I...`).
   - Common Gerrit hosts:
     - Pigweed Public: `https://pigweed-review.googlesource.com` (`pwrev.dev/<num>`)
     - Pigweed Internal: `https://pigweed-internal-review.git.corp.google.com` (`pwrev.dev/i/<num>`)
     - Fuchsia Public: `https://fuchsia-review.googlesource.com` (`fxrev.dev/<num>`)
     - Turquoise Internal: `https://turquoise-internal-review.git.corp.google.com` (`tqr/<num>`)

2. **Locate Target Commit in the Local Commit Stack (by `Change-Id`):**
   - Search the local Git commit history for the commit matching the CL's `Change-Id`:
     ```bash
     git log --grep="^Change-Id: <CHANGE_ID>$" -n 1 --format="%H %s"
     ```
   - Verify whether the commit is at `HEAD` or deeper in the stack
     (`git rev-list --count "${TARGET_SHA}..HEAD"` commits behind `HEAD`), and check `git status -s`
     to ensure the working tree is clean before starting.
   - If no commit in the local branch matches `Change-Id: <CHANGE_ID>`, stop and ask the user before
     checking out or cherry-picking the CL.

3. **Fetch Review Comments:**
   - Read `/google/src/files/head/depot/google3/learning/gemini/agents/skills/gerrit/SKILL.md` if you
     need full flag details for the `gerrit` CLI, or use the repository's native wrapper (`./gh` in
     Pigweed, `fx gh` in Fuchsia).
   - Fetch unresolved human review comments and AI review conversations:
     ```bash
     /google/bin/releases/gemini-agents-gerrit/gerrit comments list \
       --change=<ID> --host=<HOST> --unresolved-only --googlers-only
     /google/bin/releases/gemini-agents-gerrit/gerrit conversations \
       --change=<ID> --host=<HOST>
     ```
     *(Alternatively, in Pigweed run `./gh pr view [<id>] --comments`, or in Fuchsia run
     `fx gh pr view [<id>] --comments`.)*
   - Collect all **unresolved** review comment threads (`1` through `N`), ordered logically by file
     path and line number (with `/COMMIT_MSG` or patchset-level comments first).
   - If there are zero unresolved comments (or if the user asked for specific comments), inform the
     user clearly and stop.

## 2. Holistic Main-Context Analysis & Resolution Strategy Triage

Before starting the walkthrough, investigate the unresolved comments **directly in the main
context** so you have a unified mental model of the CL:

1. **Read Affected Files Once in Main Context:**
   - Read the files touched by the target commit and surrounding context (headers, implementations,
     callers, and unit tests).
   - Account for any line-number drift if comments were posted on an earlier patchset or if
     subsequent commits in a local stack also touch the same files.
2. **Determine Resolution Strategy for Each Comment (Code/Doc Update vs. Clarifying Comment):**
   - Critically evaluate whether each comment should be resolved by **updating code/documentation**
     or by **staging a clarifying comment on the code review platform**:
     - **Recommend a Clarifying Comment on the Code Review Platform when:**
       - **Direct Question / Context Inquiry:** The reviewer is asking a question to understand
         intent, architecture, threading, build configuration, or specification details, and the
         existing code is already clear and idiomatic (do not clutter the codebase with redundant
         "what" comments just to answer a review question).
       - **Intentional Trade-off / Respectful Pushback:** The reviewer suggests an alternative that
         introduces subtle issues (e.g., lifetime/WeakPtr hazards, lock-ordering issues, API
         breakage, performance regressions, or spec violations) or is intentionally handled in a
         follow-up commit in the stack.
       - **Already Handled Elsewhere:** The concern is already enforced by an existing caller, type
         invariant, test case, or another commit in the stack.
     - **Recommend a Code / Documentation / Commit Message Update when:**
       - The comment identifies a valid bug, edge case, missing test, style/rubric issue, or cleaner
         abstraction.
       - A reviewer's question reveals that a non-obvious **"why"** invariant is missing from the
         code and future readers would likely have the same confusion—warranting clearer naming or a
         concise in-code `"why"` comment.
3. **Identify Inter-Related or Coupled Comments:**
   - Check whether multiple reviewer comments are part of a single logical change (e.g., changing a
     method signature in `.h`, updating its implementation in `.cc`, and adding a test in
     `_test.cc`), or whether fixing one comment alters or obviates another.
   - Note these relationships explicitly so your proposed fixes are cohesive and never conflict with
     one another.
4. **Selective Subagent Delegation (Only When Needed):**
   - Do **not** spawn subagents merely to read the CL's own files.
   - Only spawn a read-only subagent (`research-google` or `self`) if a specific comment requires
     broad cross-codebase archaeology outside the CL's module or external specification lookup, so
     exploratory search noise stays out of the main context.

## 3. Present Summary List & Walk Through Comments One at a Time (`Comment k of N`)

Once your holistic analysis is complete:

1. **Present the Numbered Overview (`1` through `N`):**
   - Report the target commit (`<short_sha> "<subject>"`, `Change-Id: <CHANGE_ID>`) and whether it
     is at `HEAD` or `<M>` commits deep in the stack.
   - Display a concise numbered summary of all `N` unresolved comments with clickable `file://`
     links, reviewer names, recommended action tag (`[Code Fix]`, `[Doc/Comment Update]`,
     `[Commit Msg]`, or `[Clarifying Reply]`), and one-line summaries (calling out any comments that
     are coupled or inter-related).
   - In the **same turn**, immediately present **Comment 1 of N** in full detail and ask the user
     how they want to proceed.

2. **Execute the Walkthrough Loop for Each `Comment k of N` (`k = 1 ... N`):**

   ### Step A: Present `Comment k of N` & Ask How to Proceed
   - Evaluate against the **current working tree state** (accounting for any edits already amended
     in `Comments 1 .. k-1`).
   - Present **Comment `k` of `N`** with:
     - **Location:** Clickable `[file:line](file:///absolute/path/to/file#L<line>)` link (and
       patchset number, e.g., `[PS3]`).
     - **Reviewer Comment:** The reviewer's name and quoted comment thread.
     - **Recommended Action:** Explicitly state whether you recommend **Updating Code/Docs** or
       **Staging a Clarifying Draft Comment on the Code Review Platform**, and explain why.
     - **If recommending a Code/Doc/Commit-Message Fix:**
       - **Suggested Fix:** Clear explanation of the exact changes needed in source, test, or commit
         message to address it (plus any alternative options or notes on coupled comments).
       - **Proposed Diff:** Include a ` ```diff ` block showing the proposed change if it is concise
         ($\le$ ~30 lines). If the change is large or mechanical across many sites, summarize the
         edits instead of emitting a massive diff.
       - Ask the user whether they want to **apply this suggested fix**, **stage a clarifying draft
         comment instead**, **modify the approach**, or **skip it**.
     - **If recommending a Clarifying Comment on the Code Review Platform:**
       - **Why No Code Change Is Needed:** Concise technical explanation of why responding on the
         code review platform is preferable to modifying the code or documentation.
       - **Proposed Draft Reply:** A `> ` blockquote or code block with the exact, concise,
         collegial technical response to stage as a draft on the reviewer's comment thread.
       - Ask the user whether they want to **stage this clarifying draft comment**, **edit the reply
         text**, **make a code/doc change instead**, or **skip it**.
   - **Stop and wait** for the user's response before editing any files or staging any comments.

   ### Step B: Execute the Chosen Action for ONLY `Comment k`
   - **If the user chooses to skip Comment `k`:**
     - Immediately present and ask about **Comment `k + 1` of `N`**.
   - **If the user chooses a Clarifying Comment on the Code Review Platform:**
     - **Stage the approved reply strictly as an unpublished draft** on the reviewer's thread on the
       code review platform (always passing `--draft` with `./gh pr comment` / `fx gh pr comment`,
       or using `gerrit comments reply` without publishing—never submit/publish the reply).
     - Confirm the draft reply has been staged, and in the **same turn**, immediately present and
       ask about **Comment `k + 1` of `N`**.
   - **If the user chooses a Code / Documentation Fix:**
     - Edit the source and unit test files **strictly for Comment `k` only** (do not bundle fixes
       for other comments).
     - Run the relevant build and unit tests to verify the fix compiles cleanly and passes all
       tests.
     - Run `git diff` and present a concise summary of the changes made and test results for
       Comment `k`.

   ### Step C: Pause for User Review Before Amending (Code/Doc Fixes)
   - **Pause after showing the diff and test results** so the user can inspect the fix in isolation.
   - Ask the user if they are happy with the changes and ready to **amend the target commit**
     (`Change-Id: <CHANGE_ID>`), or if they would like to **make adjustments** first.
   - If the user requests refinements, apply them, re-run tests, show the updated `git diff`, and
     confirm before amending.

   ### Step D: Amend the Target Commit (by `Change-Id`) and Advance to `Comment k + 1 of N`
   - Once the user approves the code/doc fix:
     1. Re-locate the target commit SHA by `Change-Id`:
        `TARGET_SHA=$(git log --grep="^Change-Id: <CHANGE_ID>$" -n 1 --format="%H")`
     2. Amend the target commit (preserving `Change-Id:`):
        - If `TARGET_SHA` is `HEAD`: `git commit -a --amend --no-edit`
        - If `TARGET_SHA` is deep in the stack:
          `git commit -a --fixup="$TARGET_SHA" && GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash "${TARGET_SHA}~1"`
   - In the **same turn** immediately after amending, present and ask the user about
     **Comment `k + 1` of `N`**.
   - Repeat this cycle until all `N` comments have been walked through.

## 4. Final Summary

- Once all `N` comments have been resolved or skipped, present a concise summary of:
  - Which comments were resolved via code/doc fixes (all amended into the target commit matching
    `Change-Id: <CHANGE_ID>`).
  - Which comments have clarifying draft replies staged on the code review platform.
  - Which comments were skipped.
  - The resulting local Git commit stack (`git log --oneline -n <count>`).
- Never publish staged draft comments or push new patchsets to the code review platform.
