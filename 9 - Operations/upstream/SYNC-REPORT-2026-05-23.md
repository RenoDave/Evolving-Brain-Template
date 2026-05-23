# Upstream sync report — 2026-05-23

First sync run since the initial pin on 2026-04-10.

## gbrain

- **Repo:** [garrytan/gbrain](https://github.com/garrytan/gbrain)
- **Pinned:** `e9f3c9c24d36a8bbef85ea55411cfe3001d342a3` (2026-04-10)
- **Current HEAD:** `677142a680d816771bba6c5f16c42788c537cd39` (2026-05-23 17:57 UTC)
- **Commits between:** 208
- **Latest upstream commit message:** `v0.40.6.0 feat(sync): parallel sync --all + per-source lock invariant + sources status dashboard (productionized from PR #1314) (#1324)`

The upstream project has clearly been moving fast — 208 commits in 43 days, and a v0.40.x line that didn't exist when we pinned. Several runtime-focused features (parallel sync, source dashboards, etc.) — most of which are out of scope after our pivot to the Google Drive MCP.

### Tracked-file changes (size comparison)

| File | Local (pinned) | Upstream HEAD | Δ | Adoption level | Recommendation |
|---|---:|---:|---|---|---|
| `CLAUDE.md` | 10,879 B / 213 lines | 393,288 B | +36x | Partial → AGENTS.md | IGNORE |
| `docs/GBRAIN_SKILLPACK.md` | 57,294 B / 1,281 lines | 8,557 B | −85% | Partial → workflow philosophy | CONSIDER |
| `docs/GBRAIN_RECOMMENDED_SCHEMA.md` | 65,217 B / 1,013 lines | 64,204 B | ~same | **Yes** — adopted in entity templates | **CONSIDER (priority)** |
| `docs/SQLITE_ENGINE.md` | 15,478 B / 395 lines | **DELETED upstream** | — | Reference only (Phase 6 upgrade path) | IGNORE (delete locally on next sync) |
| `docs/ENGINES.md` | 9,681 B / 198 lines | 11,583 B | +20% | Reference only | IGNORE |
| `skills/ingest/SKILL.md` | 3,203 B / 65 lines | 12,678 B | +4x | Partial → inbox processing | IGNORE (post-pivot) |
| `skills/query/SKILL.md` | 2,756 B / 60 lines | 6,272 B | +2.3x | Partial → query workflow | CONSIDER |
| `skills/maintain/SKILL.md` | 3,506 B / 97 lines | 17,679 B | +5x | Partial → maintain workflow | IGNORE |
| `skills/briefing/SKILL.md` | 2,794 B / 81 lines | 6,104 B | +2.2x | Partial → briefing workflow | IGNORE |
| `skills/enrich/SKILL.md` | 1,738 B / 45 lines | 11,361 B | +6.5x | Reference only (out of scope) | IGNORE |
| `skills/migrate/SKILL.md` | 2,927 B / 72 lines | 4,986 B | +1.7x | Partial → migrate workflow | IGNORE |

### Recommendation rationale (per file)

**`CLAUDE.md` — IGNORE.** Ballooned 36x. Almost certainly became the consolidated runtime-agent instructions for gbrain itself (CLI flows, test DB lifecycle, ship workflow). Not relevant to our markdown vault after the pivot. Our `AGENTS.md` is purpose-built and stable.

**`docs/GBRAIN_SKILLPACK.md` — CONSIDER.** Shrunk 85% — the giant single-doc skillpack appears to have been split into many smaller files (which matches the corresponding growth of the per-skill files like `ingest`, `maintain`, `enrich`). Worth skimming the new (slim) version once to see if it's now an index pattern worth borrowing for `9 - Operations/workflows/README.md`.

**`docs/GBRAIN_RECOMMENDED_SCHEMA.md` — CONSIDER (priority).** Same byte count, so likely a rewrite rather than an expansion. This is the ONLY file in the manifest marked "Yes — adopted" (our `People/`, `5 - Projects/`, `6 - Areas/` templates lift directly from this). If the schema thinking has evolved — new fields, changed conventions for IDs, citations, contradictions — we'd want to know before letting drift accumulate.

**`docs/SQLITE_ENGINE.md` — IGNORE (then unlist).** File deleted upstream. We pivoted to Drive MCP, so the SQLite upgrade path is dead for us too. Next sync, drop the row from `UPSTREAM.md` and delete the local pinned copy. The fact that gbrain itself walked away from this design is informational — they probably went the same direction we did.

**`docs/ENGINES.md` — IGNORE.** Modest growth (+20%). Likely new engine types. We're not adding engines.

**`skills/ingest/SKILL.md` — IGNORE for now.** Quadrupled in size. Our inbox processor was just cleaned up and is in flight to GitHub Actions. Let the local version settle before pulling in upstream churn.

**`skills/query/SKILL.md` — CONSIDER.** More than doubled. Our `query.md` workflow is small and rarely used; if the upstream rewrite includes better synthesis or citation patterns, low-effort win.

**`skills/maintain/SKILL.md` — IGNORE.** Grew 5x but much of upstream maintain is gbrain-runtime-specific (Postgres RLS, schema versions, `gbrain doctor`). Not relevant.

**`skills/briefing/SKILL.md` — IGNORE.** Slight growth. Our briefing workflow is in active development. Don't churn it without a specific reason.

**`skills/enrich/SKILL.md` — IGNORE.** Out of scope — we're not planning external-API enrichment (Crustdata, Exa).

**`skills/migrate/SKILL.md` — IGNORE.** Slight growth. Our migrate workflow is stable. No reason to touch it.

## Summary

| Recommendation | Count | Files |
|---|---:|---|
| ADOPT | 0 | — |
| CONSIDER | 3 | `GBRAIN_RECOMMENDED_SCHEMA.md` (priority), `GBRAIN_SKILLPACK.md`, `skills/query/SKILL.md` |
| IGNORE | 8 | `CLAUDE.md`, `SQLITE_ENGINE.md` (deleted), `ENGINES.md`, `skills/ingest`, `skills/maintain`, `skills/briefing`, `skills/enrich`, `skills/migrate` |
| BLOCKED | 0 | — |

Total tracked files changed since pin: 11 of 11 (1 deleted, 10 modified).

## Single next action

**Read the diff of `docs/GBRAIN_RECOMMENDED_SCHEMA.md` before deciding whether to refresh our entity templates.** That's the only "Yes — adopted" file, and although it's the same size, a same-size rewrite is exactly the case where drift bites silently. Fetch the upstream version, diff against the pinned local copy, decide adopt-or-not.

Everything else can wait. Most of the upstream activity is gbrain-runtime evolution that's irrelevant to us post-pivot.

## After Dave reviews

When ready to close out this sync:

1. Decide ADOPT / IGNORE on each CONSIDER item.
2. If any ADOPT, refresh the local pinned copy under `9 - Operations/upstream/gbrain/` AND update our vault file that references the pattern.
3. Update `9 - Operations/upstream/gbrain/UPSTREAM.md`:
   - Bump `Pinned commit` to `677142a680d816771bba6c5f16c42788c537cd39`
   - Update `Pinned date` to today
   - Update `Last sync run` to today
   - Drop the `docs/SQLITE_ENGINE.md` row from the tracked-files table (file removed upstream; we pivoted away from SQLite anyway)
   - Append a row to the History table: `2026-05-23 | First sync run | 208 commits ahead — 3 CONSIDER, 8 IGNORE, 1 file unlisted`
4. Delete `9 - Operations/upstream/gbrain/docs/SQLITE_ENGINE.md` locally (the file's gone upstream and the path is moot for us).
5. Append a row to `9 - Operations/runs/YYYY-MM.md`.
