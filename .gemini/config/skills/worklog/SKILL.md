---
name: worklog
description: >-
  Generates weekly engineering work logs for fsareshwala in their exact personal format by spawning
  a subagent per requested week to query primary sources directly: Gerrit (Pigweed,
  Pigweed-Internal, Fuchsia, Turquoise), Critique, Buganizer, and Google Docs/Drive (such as 1:1
  notes and design/testing docs). Use when the user invokes /worklog or asks to generate or format
  their weekly work log for one or more weeks.
---

# Weekly Work Log Generator (`worklog`)

Generates verified, copy-pasteable weekly work logs for `fsareshwala` directly from primary
engineering sources using isolated subagents so that multi-week requests run in parallel without
polluting the main conversation context.

## 1. Input Parsing & Date Normalization

The user may invoke this skill with:

- A date range: `/worklog 2026-07-13 to 2026-07-17` or `/worklog July 13 to July 17, 2026`
- A single date within a week: `/worklog 2026-07-15`
- Relative dates: `/worklog last week` or `/worklog this week`
- Multiple weeks at once (launch one subagent per week concurrently)

For each target week:

1. Compute the Monday (`Monday, Month DD, YYYY`) and Friday (`Friday, Month DD, YYYY`) dates using
   zero-padded two-digit days (`01`–`31`).
2. When querying Gerrit and Buganizer, widen the query window to cover Sunday (`YYYY-MM-DD`) through
   Saturday (`YYYY-MM-DD`) in UTC so that late Friday afternoon/evening PDT changes (which have
   Saturday UTC timestamps) and Sunday evening prep are never missed, then filter individual event
   timestamps to the target week in `America/Los_Angeles` time.

## 2. Subagent Delegation (Mandatory)

Do not run Gerrit/Buganizer/Docs queries in the main agent context. Instead, call `invoke_subagent`
with `TypeName: "self"` and `Role: "Work Log Generator (<Mon DD>-<Fri DD>)"` for each requested
week, passing the full data-gathering and formatting instructions below in the subagent `Prompt`.

## 3. Subagent Primary-Source Data Gathering Protocol

Inside the subagent, gather all activity directly from primary sources:

### Step 1: Read Required Tool Skills First

Before invoking CLI tools, read their `SKILL.md` files using `view_file`:

- Gerrit: `/google/src/files/head/depot/google3/learning/gemini/agents/skills/gerrit/SKILL.md`
- Buganizer / Docs / Activity:
  `/google/src/files/head/depot/google3/learning/gemini/agents/skills/tbox/SKILL.md`
- Google Workspace (Drive/Docs/Calendar):
  `/google/src/files/head/depot/google3/gdm/agents/helix/py/skills/google-workspace-help/SKILL.md`

### Step 2: Query Gerrit & Critique Directly

Query all four Gerrit instances using `/google/bin/releases/gemini-agents-gerrit/gerrit search`:

1. Pigweed Public (`https://pigweed-review.googlesource.com`) $\rightarrow$ shortlink:
   `pwrev.dev/<number>`
2. Pigweed Internal (`https://pigweed-internal-review.git.corp.google.com`) $\rightarrow$ shortlink:
   `pwrev.dev/i/<number>`
3. Fuchsia Public (`https://fuchsia-review.googlesource.com`) $\rightarrow$ shortlink:
   `fxrev.dev/<number>`
4. Turquoise Internal (`https://turquoise-internal-review.git.corp.google.com`) $\rightarrow$
   shortlink: `tqr/<number>`

For each Gerrit host:

- Search both authored changes (`owner:fsareshwala@google.com after:<SUN> before:<NEXT_SUN>`) and
  reviewed/commented changes
  (`(reviewer:fsareshwala@google.com OR commentby:fsareshwala@google.com) after:<SUN> before:<NEXT_SUN>`).
  Note: Gerrit's `before:` operator filters on the CL's *final* `updated` timestamp, not when a
  specific patchset or comment was added. When querying historical weeks, also search `after:<SUN>`
  without `before:<NEXT_SUN>` (with `--limit=100`) so CLs uploaded or iterated on during the target
  week that merged in a later week are not missed.
- Inspect change message timestamps (`gerrit messages list --change=<ID> --host=<HOST>`) to confirm
  what actually happened during the target Monday–Friday week (e.g., initial upload, addressing
  review comments, `Code-Review+2` approval, or submission) rather than relying only on the last
  updated timestamp of the CL.
- Also check Critique (`cl/`) if any Google3 CLs were authored or reviewed during the window.

### Step 3: Query Buganizer (`b/`) Directly

Query Buganizer using `/google/bin/releases/issues-cli/issues`:

- Search for bugs created (`reporter:fsareshwala@google.com`), commented on
  (`commentby:fsareshwala@google.com`), or assigned to (`assignee:fsareshwala@google.com`)
  `fsareshwala` with activity in the target window.
- Run `/google/bin/releases/issues-cli/issues readonly list-updates <BUG_ID>` on candidate bugs to
  verify the exact date and author of comments, investigations, or status changes.
- Filter out noise: Exclude older bugs that only matched the date range because a bot or teammate
  modified `hotlist_ids`, priority, or duplicate links without actual investigation or action by
  `fsareshwala` during that week.

### Step 4: Check 1:1 Notes & Drive/Calendar for Non-CL Engineering Work

- Check `fsareshwala`'s 1:1 notes (e.g., `1:1 Faraaz:Josh`), design docs, or calendar/rotation
  events for the week to capture high-level engineering activities that do not produce a Gerrit CL
  (such as architecture/design proposals, OKR planning, Fireteam or Flake Rotation shifts, UPF
  interoperability testing, or summit presentations).
- Note: Tuesday 1:1 meeting notes often recap CLs merged the previous week. Always verify CL
  creation/merge timestamps against Step 2 so prior-week CLs are not misattributed to the current
  week.

## 4. Formatting & Style Rules

Format the output to match `fsareshwala`'s exact weekly work log style:

- Header:
  ```text
  Monday, <Month> <DD>, <YYYY> to Friday, <Month> <DD>, <YYYY>
  ------------------------------------------------------------
  ```
  - Day numbers must be zero-padded to 2 digits (e.g., `July 06`, `July 10`, `August 03`).
  - Underline is a set of hyphens (`-`) exactly the length of the first line of the header that
    contains the dates followed by a blank line.
- Bullets:
  - Format: `- <Category>: <Concise imperative description> (<shortlink(s)>)`
  - Standard categories: `Bluetooth`, `Flake Rotation`, `Pigweed`
  - Use concise imperative mood (`Fix ...`, `Add ...`, `Move ...`, `Route ...`, `Gate ...`,
    `Review ...`, `Triage ...`, `Investigate ...`).
  - When a CL was already logged in an earlier week upon initial upload and is updated/merged in a
    later week, phrase the follow-up entry as
    `Address review comments in <CL description> and merge (<link>)` or
    `Iterate on <CL description> (<link>)`.

### Canonical Example Output

```text
Monday, July 06, 2026 to Friday, July 10, 2026
----------------------------------------------

- Bluetooth: Fix error blocking rollers due to duplicated pigweed backends (fxrev.dev/1694608)
- Bluetooth: Migrate pigweed backends to upstream (fxrev.dev/1695434)
- Bluetooth: Point Bazel overrides to upstream targets and delete wrappers (fxrev.dev/1695435)
- Bluetooth: Move Vendor Capabilities opcode usage to Emboss (pwrev.dev/338952)
- Bluetooth: Move A2DP offloading opcodes to Emboss (pwrev.dev/338953)
- Flake Rotation: Add fast fail crash detection in boot idle (tqr/1381073)
- Flake Rotation: Filter out goldfish out of bound log spam (fxrev.dev/1699965)
- Flake Rotation: Call `Deconfigure()` after `DisableAllEndpoints()` (fxrev.dev/1700462)
- Flake Rotation: Migrate `QueueRequests` to use wire FIDL vector views (fxrev.dev/1700463)
- Bluetooth: Limit l2cap signalling channel ERTX timer resets (pwrev.dev/434638)
- Bluetooth: Cap BREDR EIR service UUID set size (pwrev.dev/434639)
- Bluetooth: Guard CCC write handler against null callback (pwrev.dev/434640)
- Bluetooth: Fix LE connection matching during address resolution (pwrev.dev/434641)
- Bluetooth: Clear SecurityRequestPhase on responder encryption (pwrev.dev/434642)
- Bluetooth: Implement repeated attempts backoff in sm (pwrev.dev/434643)
- Bluetooth: Cap l2cap recombiner fragments (pwrev.dev/434644)
- Bluetooth: Cache serialized SDP payloads (pwrev.dev/434645)
```

## 5. Subagent Return Format

The subagent must return:

1. Formatted Weekly Work Log: A fenced `text` block ready to copy-paste.
2. Source Breakdown: A brief summary of the primary sources verified (authored CLs, reviewed CLs,
   bugs filed/triaged/resolved, and non-CL items from docs/calendar).
