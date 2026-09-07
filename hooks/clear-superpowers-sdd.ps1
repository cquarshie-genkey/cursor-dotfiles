# Clear completed Superpowers SDD scratch under workspace roots.
# Used by stop + sessionEnd. Keeps files if progress.md still has incomplete tasks.

$ErrorActionPreference = 'Stop'

try {
  $raw = [Console]::In.ReadToEnd()
  if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }

  $payload = $raw | ConvertFrom-Json

  $ok = $false
  if ($payload.status -eq 'completed') { $ok = $true }
  if ($payload.reason -eq 'completed') { $ok = $true }
  if ($payload.final_status -eq 'completed') { $ok = $true }
  if (-not $ok) { exit 0 }

  $roots = @()
  if ($payload.workspace_roots) { $roots += @($payload.workspace_roots) }
  if ($payload.cwd) { $roots += $payload.cwd }
  $roots = $roots | Where-Object { $_ } | Select-Object -Unique

  foreach ($root in $roots) {
    $sdd = Join-Path $root '.superpowers\sdd'
    if (-not (Test-Path -LiteralPath $sdd)) { continue }

    # Only auto-clear when the SDD ledger exists and every task is done.
    # If there is no progress.md, leave files alone (agent rule clears on finish).
    $progress = Join-Path $sdd 'progress.md'
    if (-not (Test-Path -LiteralPath $progress)) { continue }

    $lines = Get-Content -LiteralPath $progress -ErrorAction SilentlyContinue
    $taskLines = @($lines | Where-Object { $_ -match '^\s*Task\s+\d+\s*:' })
    if ($taskLines.Count -eq 0) { continue }

    $incomplete = @(
      $taskLines | Where-Object {
        $_ -notmatch '(?i)\b(complete|completed|skipped|done)\b'
      }
    )
    if ($incomplete.Count -gt 0) { continue }

    Get-ChildItem -LiteralPath $sdd -Force -ErrorAction SilentlyContinue |
      Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
  }
} catch {
  # Fail open — never block the agent on cleanup issues
}

exit 0
