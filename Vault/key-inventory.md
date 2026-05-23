# Key inventory

Human-readable catalog of every secret in `Vault/.env`. Values are NOT stored here — this file is committed.

## Active keys

| Key | What it's for | Used by | Scope | Rotation |
|---|---|---|---|---|
| `ANTHROPIC_API_KEY` | Calling the Anthropic API directly (outside Claude Code subscription flows) | Any workflow that needs raw API access | global | rotate every 90d |
| `GITHUB_TOKEN` | Reading/writing this repo from scripts and GitHub Actions | Inbox processor, connectors that commit captures | global | rotate every 90d |

## Optional / not currently used

These keys are kept in `.env.example` and `.env` for future use but are NOT required for the brain to function. The Google Drive MCP handles retrieval (see MASTER PLAN Phase 6).

| Key | What it would be for | Used by | Status |
|---|---|---|---|
| `OPENAI_API_KEY` | Embedding generation for gbrain's semantic search index | `gbrain sync`, `gbrain embed` (gbrain not currently installed) | Optional — re-enable if vault grows past ~2,000 files |
| `SUPABASE_POOLER_URL` | Postgres connection string (Session pooler, port 6543) for gbrain's retrieval layer | `gbrain init`, `gbrain sync`, all gbrain commands (gbrain not currently installed) | Optional — re-enable with gbrain |

## Deprecated / removed keys

_None._

## Rules

- Add a row when adding a key to `.env` and `.env.example`. Do it in the same commit.
- When removing a key, move its row to "Deprecated / removed" with the removal date, then delete the row entirely after a 30-day grace period.
- `Scope` is `global` or a comma-separated list of project names.
- `Rotation` is the recommended rotation cadence. The brain will nag you if a key hasn't been rotated in longer than this.
- **Never paste values into this file, even as a joke.** If you do, rotate the key immediately and rewrite git history to scrub it.

## Fields explained

- **Key** — the name as it appears in `.env` (SCREAMING_SNAKE_CASE).
- **What it's for** — one sentence a human can read in 5 seconds.
- **Used by** — which workflows, connectors, or scripts read this key.
- **Scope** — `global` or project names. Used by the runtime loader to filter which keys a given project gets.
- **Rotation** — recommended rotation cadence.
