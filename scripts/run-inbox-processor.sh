#!/usr/bin/env bash
# Run the Evolving Brain inbox processor non-interactively.
#
# Invoked by .github/workflows/inbox-processor.yml.
# Reads .inbox/, processes new captures via Claude Code, commits the results.
# The wrapping GitHub Action pushes the commit.
#
# Idempotent: the inbox processor moves processed files to .inbox/processed/,
# so re-running on an empty inbox is a no-op (exits cleanly, no commit).
#
# Required env:
#   ANTHROPIC_API_KEY — pulled from GitHub Actions secrets (NOT from Vault/.env,
#   which the runner cannot read).

set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$VAULT_ROOT"

WORKFLOW_FILE="9 - Operations/workflows/inbox processing.md"

if [[ ! -f "$WORKFLOW_FILE" ]]; then
  echo "FATAL: workflow file not found at $WORKFLOW_FILE"
  exit 1
fi

if [[ -z "${ANTHROPIC_API_KEY:-}" ]]; then
  echo "FATAL: ANTHROPIC_API_KEY not set. Add it to GitHub Actions secrets."
  exit 1
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "FATAL: claude CLI not installed. The workflow installs it via npm; check the install step."
  exit 1
fi

echo "=== Inbox processor ==="
echo "Vault: $VAULT_ROOT"
echo "Workflow: $WORKFLOW_FILE"
echo ""

# The prompt Claude follows. It points at the workflow file as the spec.
# Workflow step 7 (sync to gbrain) is no longer needed — retrieval is via
# the Google Drive MCP. Steps 1–6 are the real work.
PROMPT=$(cat <<'PROMPT_EOF'
You are running as the Evolving Brain inbox processor in a GitHub Actions runner.

Follow the workflow at "9 - Operations/workflows/inbox processing.md" exactly. It
defines the role, inputs, output, and procedure (steps 1–7). Step 7 is now a
no-op note (retrieval is via Google Drive MCP), so your work ends at step 6
(commit).

Hard constraints:
- If .inbox/ has zero unprocessed files, exit cleanly without committing.
- Never edit 0 - Identity/ files, 1 - Aspirations/GOALS.md, or 8 - North Star/NORTH STAR.md.
- Append to live logs; never rewrite history.
- Move processed files to .inbox/processed/YYYY-MM/<source>/ — never delete.
- Cite sources via [[wiki links]] on every log entry and timeline entry.
- One commit per run, with the message format the workflow specifies.

Do NOT push — the wrapping GitHub Action handles push.

Exit non-zero if you hit a fatal error so the Action can surface it as a GitHub Issue.
PROMPT_EOF
)

# Non-interactive invocation:
#   --print              one-shot mode (no REPL, exit when done)
#   --permission-mode acceptEdits  pre-approve file edits in CI
#   --output-format text human-readable run log
#
# If a flag name has drifted in a newer Claude Code release, update here.
# Reference: https://docs.claude.com/en/docs/claude-code/sdk
claude --print --permission-mode acceptEdits --output-format text "$PROMPT"

echo ""
echo "=== Processor done ==="
