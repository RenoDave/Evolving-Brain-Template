---
description: Generate today's Activation Report — TOP 3, ONE THING, watch / delegate / network / anchor, tied to your North Star
argument-hint: (no argument) — reads the vault and outputs the report
---

Generate an Activation Report against this vault. Modeled on the Cowork `renobuilt-activate` skill, adapted for Claude Code — no Gmail / Calendar / QBO access, vault-only. Plain English. Canadian spelling. No emojis.

## Procedure

### 1. Load context

Read in order:

1. `8 - North Star/NORTH STAR.md` — the three metrics + 90-day targets (treat 90-day targets as the current quarterly targets)
2. `1 - Aspirations/ACTIVE PROJECTS.md` — index of what's in flight
3. `5 - Projects/` — entity pages for active projects. Read the compiled-truth section only; skip timelines unless one is needed to disambiguate
4. `6 - Areas/` — ongoing responsibilities
5. `People/` — relationships you may want to nudge today
6. `2 - Live Logs/ASSISTANT_ACTIONS_LOG.md` last 7 entries — what Claude has been recommending lately, to avoid repeating yesterday's pick
7. `2 - Live Logs/ACTIONS_LOG.md` last 7 days — what Dave actually did, to avoid recommending what's already done
8. `1 - Aspirations/GOALS.md` and `1 - Aspirations/HABITS.md` — what Dave said he's optimizing for
9. `1 - Aspirations/12 FAVORITE PROBLEMS.md` — the problems Dave is willing to spend time on
10. `0 - Identity/SOUL.md` — for the Anchor line only

### 2. Check quarterly targets

Read the three `90-day target:` slots in `NORTH STAR.md`.

- If all three are populated, use them as the current quarterly targets and proceed.
- If any of them is empty, missing, or says `_fill in_` / `_Set after 90-day target is hit_`, ask **one focused question**:

  > "Your 90-day target for {metric} is not set in NORTH STAR.md. What's the target for the next 90 days?"

  Save the answer directly into `NORTH STAR.md` at the matching `90-day target:` line. **Do not** create a separate `8 - North Star/YYYY-Qn-targets.md` — NORTH STAR.md is the canonical place per its own self-declared rule ("Quarterly... This is the only place targets should get edited").

  Note the new target in `2 - Live Logs/DECISIONS_LOG.md` with a `→ [[NORTH STAR]]` citation.

### 3. Synthesize

For each section of the report:

**TOP 3 — DO THESE TODAY**
Three items, ranked by leverage. Each must:
- Move at least one of the three North Star metrics (call it out by name)
- Be doable today (under ~8 hours of total work across all three combined)
- Be specific (not "work on X" — "draft the email to Y" or "call Z about A")

**ONE THING**
If today went sideways and Dave only got ONE thing done, what should it be? Pick the highest-leverage of TOP 3 — restate it in one line.

**WATCH**
One or two things bubbling — not urgent today, but worth keeping eyes on. Could be: a project drifting, a deadline coming, a relationship going cold, a metric trending the wrong way. Cite the source: `→ [[file]]`.

**DELEGATE / AUTOMATE / KILL**
One item from Dave's current workload that he's still doing manually but shouldn't be. Tag it: **D** (delegate to someone), **A** (automate it), or **K** (just stop doing it). One sentence why.

**NETWORK NUDGE**
One person from `People/` who Dave should reach out to today. Pick based on: last interaction was 30+ days ago AND there's either an open thread or a relationship-value reason to reconnect. If no good candidate exists, say "no network nudge today" and move on. Don't fabricate.

**ANCHOR**
A 1-line reminder of why Dave is doing all of this. Pull from `0 - Identity/SOUL.md` or `1 - Aspirations/GOALS.md` — the personal mission, the 10-year picture, the next-decade vision. Should land like a kick, not a hug.

### 4. Avoid repetition

Check the last 3 days of `ASSISTANT_ACTIONS_LOG.md` for prior `/activate` runs. If the same recommendation appears and there's no matching entry in `ACTIONS_LOG.md` showing it got done, mark it explicitly: "still pending from YYYY-MM-DD". Don't pad with new items just to fill three slots — three stale recommendations is more honest than three filler ones.

### 5. Sources thin footer

List what you couldn't read because the connector isn't in this Claude Code session:

- Gmail
- Calendar
- QuickBooks Online

If any of those MCPs IS connected in the current session, drop it from the list. If all three are missing, list all three. This is how Dave knows the report is partial vs. complete.

### 6. Output

Print the report in this exact shape:

```
ACTIVATION REPORT — YYYY-MM-DD

TOP 3 — DO THESE TODAY

1. {action}
   Why: {one sentence tied to a North Star metric or stated goal}
   First move: {the exact next physical action — keystroke-level specific}
   Time: {estimate}
   Leverage: {1-10}
   Source: → [[link to project / area / log]]

2. {action}
   Why: ...
   First move: ...
   Time: ...
   Leverage: ...
   Source: → [[link]]

3. {action}
   Why: ...
   First move: ...
   Time: ...
   Leverage: ...
   Source: → [[link]]

ONE THING
If today goes sideways: {restate the highest-leverage TOP 3 item in one line}.

WATCH
- {thing} — {one-line context} → [[source]]
- {optional second}

DELEGATE / AUTOMATE / KILL
{D|A|K}: {item} — {one-line reason} → [[source]]

NETWORK NUDGE
{Person} — last contact {YYYY-MM-DD}, {one-line context for nudge}. Suggested move: {specific action — text / call / draft intro to X}. → [[People/<name>]]

ANCHOR
{1 line, plain language} → [[source]]

Sources thin: {comma-separated list of what was missing, or "none — full vault context"}
```

## After printing the report

Ask Dave:

- **Make the first move now** — start on TOP 1 (open the draft, dial the number, write the message)
- **Adjust the picks** — push back on a recommendation and regenerate
- **Log the report** — write it to `4 - Meetings/YYYY-MM-DD activation.md` (same shape as `/brain-brief --save`) and `git add` + `git commit` with message `activation: YYYY-MM-DD`. Do not push.
- **Done for now** — exit without saving

## Rules

- **Never invent context.** If a project has no compiled-truth section, say "no current state recorded" — don't make one up.
- **Never fabricate Network Nudge candidates.** If no one in `People/` fits the criteria, say so.
- **Never recommend something Dave already did.** Check `ACTIONS_LOG.md` for the last 7 days first.
- **Never include a TOP 3 item that doesn't tie back to a North Star metric or a stated goal.** If a candidate doesn't move one of the three, demote it.
- **Never schedule, send, post, or file anything.** This command is read-only on the vault and write-only for (a) the optional saved report at `4 - Meetings/YYYY-MM-DD activation.md` if Dave asks for "Log the report", and (b) `NORTH STAR.md` if quarterly targets needed setting.
- **Never edit `0 - Identity/`, `1 - Aspirations/GOALS.md`, `8 - North Star/NORTH STAR.md`** beyond the one specific case in step 2 (filling in a missing 90-day target after Dave answers the focused question).
- **Never use emojis.** Plain text only.
- **Never pad with "I hope this helps!" or similar.** End at the Sources thin footer.

## Why this exists

The Cowork `renobuilt-activate` skill reads across the vault + Gmail + Calendar + QBO and outputs the Activation Report. This command is the vault-only Claude-Code-flavoured version — same report shape, fewer sources. Use it when Dave is in Claude Code and wants the activation lens without leaving the terminal. When the connectors below are eventually wired into Claude Code (or this command grows to use them), update the "Sources thin" footer logic accordingly.
