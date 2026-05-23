# Workflows registry

Every workflow Claude can run in this vault, with its current state.

This table is an **aggregated view**. The source of truth for each workflow is the frontmatter of its own file. When Claude finishes a run, it updates the file's frontmatter and regenerates this table.

## Active

| Workflow | Schedule | Scope | Last run | Next run | File |
|---|---|---|---|---|---|
| Inbox processing | every 3h (`0 */3 * * *`) — **cron disabled, manual only** | global | — | — | [[inbox processing]] |
| Onboarding processing | one-time (2 modes: bulk-only, full) | global | — | — | [[onboarding processing]] |
| Dream cycle | nightly 03:00 (`0 3 * * *`) | global | — | — | [[dream cycle]] |
| Briefing | mornings 07:00 (`0 7 * * *`) | global | — | — | [[briefing]] |
| Weekly review | Mondays 09:00 (`0 9 * * MON`) | global | — | — | [[weekly review]] |
| Sync upstream | Mondays 06:00 (`0 6 * * MON`) | global | — | — | [[sync upstream]] |
| Maintain | Sundays 04:00 (`0 4 * * SUN`) | global | — | — | [[maintain]] |
| Journal processing | manual | global | — | — | [[journal processing]] |
| Meeting processing | on-capture (triggered by inbox) | global | — | — | [[meeting processing]] |
| Query | on-demand | global | — | — | [[query]] |
| Migrate | on-demand | global | — | — | [[migrate]] |
| Generate wiki | manual | global | — | — | [[generate wiki]] |

## Paused

_None._

## Archived

_None._ Archived workflows live in `9 - Operations/workflows/archived/` and do not run.

---

## The workflow categories

Workflows fall into four categories:

1. **Capture + synthesis** — `inbox processing`, `journal processing`, `meeting processing`, `onboarding processing`, `migrate`. Get external signal into the vault as structured content.
2. **Maintenance** — `dream cycle` (nightly), `maintain` (weekly), `sync upstream` (weekly), `generate wiki` (on demand). Keep the vault healthy and in sync.
3. **Review + reflection** — `weekly review`, `briefing`. Look backward (review) or forward (briefing) to surface what matters.
4. **Read** — `query`. Answer a specific question from the vault.

## Adding a new workflow

1. Create a new `.md` file in this folder (or in `5 - Projects/<project>/workflows/` for project-scoped).
2. Add frontmatter: `status`, `schedule`, `scope`, `last_run`, `next_run`, `owner`.
3. Write the prompt Claude will follow when the workflow runs.
4. Add a row to the Active table above.

## Archiving a workflow

1. Move the file to `archived/`.
2. Set `status: archived` in frontmatter.
3. Remove the row from Active and add a single-line entry under Archived with the archive date.

## Schedule format

Use cron syntax for scheduled workflows. Human annotations in a comment after the cron string are encouraged. Non-scheduled: `manual`, `one-time`, `on-demand`, `on-capture`, or `on-event:<event-name>`.

## Running the inbox processor on GitHub Actions

The inbox processor has a scaffolded GitHub Actions workflow at `.github/workflows/inbox-processor.yml`. It runs the prompt in `inbox processing.md` against the latest commit on `main`, then commits + pushes the synthesized output.

### Current state — scaffolded, cron disabled

- Trigger: `workflow_dispatch` only (manual button-click in the Actions tab)
- Cron block exists but is commented out — uncomment when first manual run is green
- Concurrency group `inbox-processor` serializes runs; no overlapping processors
- Push permission comes from the workflow's default `GITHUB_TOKEN` with `contents: write`
- `ANTHROPIC_API_KEY` is read from GitHub Actions secrets (not from `Vault/.env` — the runner cannot read your local env file)

### To enable

1. Add `ANTHROPIC_API_KEY` to GitHub Actions secrets:
   - Repo Settings → Secrets and variables → Actions → New repository secret
   - Name: `ANTHROPIC_API_KEY`, value: your Anthropic key.
2. **Add `INBOX_PROCESSOR_PAT` (recommended — makes push robust to branch protection).** Create a fine-grained Personal Access Token:
   - GitHub → Settings (personal) → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token
   - Resource owner: your user (RenoDave). Scope: Only select repositories → pick this repo.
   - Repository permissions: `Contents: Read and write`. Leave everything else at "no access".
   - Set an expiration (90 days is reasonable; the workflow will fail with a clear message when it expires).
   - Copy the token, then in this repo: Settings → Secrets and variables → Actions → New repository secret. Name: `INBOX_PROCESSOR_PAT`, value: the token.
   - The workflow falls back to the default `GITHUB_TOKEN` if `INBOX_PROCESSOR_PAT` isn't set. That fallback only works when `main` has no branch protection — set the PAT and you're covered either way.
3. Trigger a test run manually: Actions tab → "Inbox processor" → Run workflow → main.
4. Watch the run log. Confirm it processed files (or exited cleanly on an empty inbox), committed, and pushed.
5. Once verified, edit `.github/workflows/inbox-processor.yml` and uncomment the two `schedule:` lines to activate the cron (`0 */3 * * *` UTC by default).

### To disable

- Comment the `schedule:` block again, OR
- Disable the workflow from the Actions tab UI (Workflows → "Inbox processor" → "..." → Disable workflow)

### Where to find logs

- Per-run logs: GitHub Actions tab → "Inbox processor" → click a run
- Per-run summary committed to the vault: `9 - Operations/runs/YYYY-MM.md` (appended by the processor itself)
- Failure issues: if a run errors, the Action opens a GitHub Issue tagged `automation` + `inbox-processor`. Three+ failures in a row = consider disabling the cron until the cause is fixed.

### Failure mode

If the run errors at any step, the Action opens a GitHub Issue with the run URL and a fix-and-re-trigger checklist. The Action exits non-zero; the cron just tries again at the next scheduled time. Concurrency group prevents pile-ups.

### Why this design

- **Free** — GitHub Actions runners on a private repo are free up to 2,000 min/month. Each run is <30s on an empty inbox, ~1-2min with a small batch. We use <60 min/month.
- **Auditable** — Every run has logs, every commit has a message, every failure has an issue.
- **Idempotent** — Inbox processor moves files to `.inbox/processed/` after handling. Re-running on an empty inbox is a no-op.
- **Reversible** — If a run produces a bad commit, `git revert` undoes it. Or disable the cron and process manually.
