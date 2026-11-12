# Writing for Engineers

The person reading a code review comment, review reply, commit message, bug comment, or technical
explanation knows the domain and the codebase. They have the diff open in front of them, but they
have not seen your investigation. They read once from the top and stop when they have what they
need.

Agent prose often fails because it is written for the wrong reader: someone who needs every term
defined, who will audit your tool calls, or who takes in a block of text all at once instead of one
sentence at a time. Write so a tired colleague understands on the first read.

## Core Principles

1. **Write from what you understand, not from what you read.**
   At the end of an audit your context is full of scaffolding: the files you opened, the call
   chains you traced, grep hits, and exact line numbers. An engineer who did the same work forgets
   most of that scaffolding before writing and writes down only the explanation. Do that on purpose:
   set the evidence aside, work out what you now believe is true and why, and say it in one or two
   plain sentences the way you would tell a colleague at your desk. Tell the reader what is true,
   not how you found it. Mention your investigation path only when it rules out the cause the reader
   would suspect first. Never copy-paste from audit tables or working notes.

2. **Put the point first.**
   The reader should know the bug, trade-off, or answer after the first sentence or two. Every
   sentence after that helps them understand it, trust it, or act on it. Skip throat-clearing,
   context preambles, and meta-talk (*"This CL..."*, *"The author should..."*, *"It is important to
   note that..."*).

3. **Cut every word that does no work, and use the short, everyday word.**
   If a sentence survives without a word, cut the word. *"In order to"* is *"to"*. Use *"use"* (not
   *"utilize"*), *"help"* (not *"facilitate"*), *"do"* (not *"perform"*), *"move"* or *"delete"*
   (not invented jargon like *"evacuate"*, *"ratchet"*, or *"endgame"*). A long word must buy its
   length with precision. When a writing rule makes a sentence sound like a machine wrote it, break
   the rule and fix the sentence.

## Let the Reasoning Unfold in Order

Readers take in prose one sentence at a time. Start each sentence from something the reader already
has and add one new thing (`old-before-new`), walking cause and effect in the direction it runs:

- **Make actors the subjects and actions the verbs.** Write *"teardown closes the bridge windows"*,
  not *"closure of the bridge windows occurs during teardown"*.
- **Name the mechanism.** Phrases like *"leads to"*, *"results in"*, *"cascades into"*, *"impacts"*,
  *"is related to"*, and *"can cause issues"* stand in for a relationship you haven't stated. Say
  what X actually does to Y: *"the allocator is misconfigured; it feeds the downstream processor,
  which is why the processor produces bad data."*
- **Put conditions before the statements or instructions they guard.** Write *"If `count == 0`,
  `span.first(count - 1)` underflows"*, or *"To lower the committed budget, run `budget.mjs
  --write`."*
- **Vary sentence rhythm on purpose.** Give each sentence one main thought, not one uniform clipped
  length. Short sentences land a point. Longer sentences carry a fact together with its condition or
  consequence.

## Keep a Detail Only If It Does Work for the Reader

Precision is not detail. Keep a detail only when the reader needs it to act, to find something, or
to believe a claim they would otherwise doubt. Everything else is proof of work that costs attention
and buries the point:

- **Name concepts, not call chains.** An engineer thinks in terms of *"teardown"*, *"the bridge
  windows"*, and *"the command register"*, not `Bus::~Bus -> Bridge::Disable ->
  Device::DisableLocked`. If the path matters, name its ends: *"teardown ends up calling
  `PowerDownChip`."*
- **Reserve code font for what the reader would type or search for.** Use backticks for real
  symbols, protocol fields (`wLength`), flags, file paths, and commands. Domain terms (`EP0`, `TRB`,
  `D3hot`) are plain words.
- **Don't repeat what the diff or UI already shows.** An inline Gerrit comment is already anchored
  to the file and line; don't open by restating the file name, line number, or function name. A
  commit message sits right above the diff; don't walk through which functions changed.
- **State certainty once and plainly.** Write *"confirmed on device"* or *"likely, but not
  reproduced yet"* when it matters. Don't stamp every sentence *"verified"*.

## Leave No Sentence Open to Two Readings

- **Pin modifiers to the word they change.** *"Only fails on growth"* and *"fails only on growth"*
  say different things.
- **Make every *"it"*, *"they"*, and *"this"* point to one obvious noun.** Repeat the noun when in
  doubt. Never use a bare *"this"* or *"which"* to point at an entire preceding clause.
- **Break up noun piles.** Write *"the script that checks the proto-import budget"*, not *"the proto
  import budget check script"*.
- **Use clean punctuation.** Prefer periods over semicolons and em dashes. Write *"a, b, or both"*
  instead of *"a/b"* or *"and/or"*, and never form plurals with `"(s)"`.
- **Call each thing by one name everywhere.** Don't call the same mechanism *"the gate"*, *"the
  ratchet"*, and *"the budget check"* across three sentences.

## Choose the Format by the Shape of the Content

- **Prose is the default for explanation.** Connecting words (*because, so, but, which means,
  instead*) carry the reasoning. Splitting a single argument into bullets deletes those words and
  forces the reader to reassemble the logic.
- **Use a numbered list only for a real sequence** (a timeline of events, steps to reproduce, or a
  numbered index of separate findings in a chat summary).
- **Use bullets only for parallel, independent items** (unrelated fixes across components or
  alternatives considered). Introduce the list with a sentence saying what ties the items together,
  and start each bullet with the component or subject so the reader can scan down the left edge.
- **Never put bold section labels or headers inside review comments, replies, bug comments, or
  commit messages.** Do not write `**Issue:**`, `**Root Cause:**`, `**Impact:**`, or
  `**Suggested Fix:**` inside a Gerrit comment or commit description. The first sentence of a short
  paragraph already does the job of a label.

## What Each Kind of Writing Needs

- **Inline Gerrit review comment (`code-review`):** State the problem or question in the first
  sentence, give the mechanism in the next, and state the fix (or include a short code block) if it
  isn't obvious. Write in direct peer voice (*"If `len == 0` here..."* or *"nit: Can we share this
  clamping helper with `FooChannel`?"*). Two to four sentences of plain prose is almost always
  enough.
- **Reply to a reviewer (`address-cl-comments`):** Answer their question or state what you changed
  in the first sentence, then give the reason. If you are pushing back or offering an alternative,
  state the trade-off plainly without defensiveness or filler.
- **Commit message (`code-fix` / `address-cl-comments`):** Explain why the change exists—the
  situation, its cause, and the approach at the level of concepts—so a reviewer understands why the
  CL exists before opening the diff. Mention what a reviewer would otherwise ask about (a
  non-obvious trade-off, a rejected alternative, a behavior change). Follow the repository's subject
  and footer conventions.
- **Longer docs and explainers:** Pick one Diátaxis mode (*tutorial*, *how-to*, *reference*, or
  *explanation*) and don't mix them. Open with the whole thing in miniature, start each section from
  the problem it solves, and use headings that carry the point (*"Pick the mode first"*, not
  *"Modes"*).

## Revise as the Reader (Pre-Output Check)

Before staging a Gerrit draft comment, amending a commit message, or sending a summary, reread the
draft as someone who wasn't there:

1. **Read only the first two sentences.** Do you already know the point?
2. **Read one sentence at a time.** Does each sentence build on what came right before it without
   using something before it is explained?
3. **Audit every identifier, path, call chain, and number.** Ask what the reader loses without it;
   if the answer is nothing, cut it or replace it with the concept it stands for.
4. **Check the structure.** If a bullet list is really one causal argument, turn it back into a
   paragraph. Strip any `**Root Cause:**` / `**Fix:**` labels from comments and commit messages.
5. **Read it aloud.** Would an engineer say it this way to a colleague? Agent first drafts typically
   run two to three times longer than necessary—cut the scaffolding, keep the mechanism.

## Worked Examples

### Inline Gerrit Review Comment
**Before (AI report style):**
> **Issue:** Potential Integer Underflow in Packet Parser
> - **Root Cause:** In `ParseHeader()`, `payload_len` is computed as `total_len - kHeaderSize`
>   after `Transport::OnRead -> Channel::Dispatch -> Parser::ParseHeader`. However, the check on
>   line 84 only verifies `total_len > 0` instead of `total_len >= kHeaderSize`.
> - **Impact:** This cascades into an unsigned wrap-around of `payload_len`, which results in an
>   out-of-bounds read assertion failure in `pw::span::subspan`.
> - **Recommendation:** Update the guard condition to check `total_len < kHeaderSize`.

**After (Engineer peer voice):**
> `total_len` is only checked for `> 0` above, so a short packet (`0 < total_len < kHeaderSize`)
> wraps `total_len - kHeaderSize` and crashes in `subspan()`. Guard with `total_len < kHeaderSize`
> instead.

### Reviewer Reply
**Before (AI style):**
> Great question! It is important to note that we cannot move `ResetState()` into `Close()` because
> `Close()` is invoked from the error callback path while `lock_` is still held by `SendFrame()`,
> which would result in a recursive mutex acquisition deadlock.

**After (Engineer peer voice):**
> `Close()` runs from the error callback while `SendFrame()` still holds `lock_`, so calling
> `ResetState()` there would deadlock on `lock_`. Resetting after `SendFrame()` releases the lock
> avoids re-entering it.

### Commit Message Body
**Before (AI investigation transcript):**
> During teardown in `Bus::~Bus()`, `Bridge::Disable()` calls `Device::DisableLocked()`, which
> clears the PCI command register and zeroes the bridge memory windows. When the driver rebinds
> later, `Bridge::Bind()` assumes the BIOS configuration is still intact and does not reprogram the
> windows, leading to downstream BAR accesses failing with `ZX_ERR_IO`. This CL updates `Bind()` to
> restore the bridge window registers.

**After (Engineer style):**
> Teardown wipes out the bridge window configuration, and nothing restores it before the next
> instance of the driver binds. Save the window registers before teardown and restore them in
> `Bind()` so rebinding devices can still reach downstream BARs.
