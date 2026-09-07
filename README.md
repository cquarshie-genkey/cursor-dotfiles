# cursor-dotfiles

Backup of machine-local Cursor skills, rules, hooks, and the shared GenKey troubleshooting log. These files are not tracked in company repos (user-level Cursor config, or gitignored `.cursor/` folders).

Remote: https://github.com/cquarshie-genkey/cursor-dotfiles

## Restore after a new PC or Cursor reset

Copy back to the same paths. Create destination folders if they are missing.

| This repo | Restore to |
|---|---|
| `skills/*` | `%USERPROFILE%\.cursor\skills\` |
| `user-rules\*.mdc` | `%USERPROFILE%\.cursor\rules\` |
| `hooks\clear-superpowers-sdd.ps1` | `%USERPROFILE%\.cursor\hooks\` |
| `hooks.json` | `%USERPROFILE%\.cursor\hooks.json` |
| `genkey-projects\TROUBLESHOOTING.local.md` | `C:\dev\genkey projects\.cursor\` |
| `genkey-projects\rules\*.mdc` | `C:\dev\genkey projects\.cursor\rules\` |
| `spire-ui-rules\*.mdc` | `C:\dev\genkey projects\spire-ui\.cursor\rules\` |

Optional: also copy `genkey-projects\rules\spire-consoles-conventions.mdc` and `use-case-patterns.mdc` into `C:\dev\genkey projects\spire-consoles\.cursor\rules\` if you want the project-local copies.

PowerShell:

```powershell
$src = "$env:USERPROFILE\cursor-dotfiles"
Copy-Item -Recurse "$src\skills\*" "$env:USERPROFILE\.cursor\skills\" -Force
Copy-Item "$src\user-rules\*" "$env:USERPROFILE\.cursor\rules\" -Force
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.cursor\hooks" | Out-Null
Copy-Item "$src\hooks\clear-superpowers-sdd.ps1" "$env:USERPROFILE\.cursor\hooks\" -Force
Copy-Item "$src\hooks.json" "$env:USERPROFILE\.cursor\hooks.json" -Force
New-Item -ItemType Directory -Force -Path "C:\dev\genkey projects\.cursor\rules" | Out-Null
Copy-Item "$src\genkey-projects\TROUBLESHOOTING.local.md" "C:\dev\genkey projects\.cursor\" -Force
Copy-Item "$src\genkey-projects\rules\*" "C:\dev\genkey projects\.cursor\rules\" -Force
New-Item -ItemType Directory -Force -Path "C:\dev\genkey projects\spire-ui\.cursor\rules" | Out-Null
Copy-Item "$src\spire-ui-rules\*" "C:\dev\genkey projects\spire-ui\.cursor\rules\" -Force
```

## Installed Cursor plugins (reinstall; not copied here)

These come back by installing the plugin in Cursor. They are not backed up as files in this repo.

### Superpowers (obra / cursor-public)

Agent workflow skills. Reinstall the Superpowers plugin after a reset.

- `using-superpowers` — invoke relevant skills before acting
- `brainstorming` — design before implementation
- `writing-plans` / `executing-plans` — multi-step plans
- `subagent-driven-development` — independent implementation tasks
- `dispatching-parallel-agents` — parallel work
- `systematic-debugging` — root-cause before fixes
- `test-driven-development`
- `verification-before-completion`
- `requesting-code-review` / `receiving-code-review`
- `finishing-a-development-branch`
- `using-git-worktrees`
- `writing-skills`

### Atlassian (Claude / MCP skills)

Jira and Confluence. Reinstall the Atlassian plugin and sign in.

- `search-company-knowledge`
- `triage-issue`
- `spec-to-backlog`
- `capture-tasks-from-meeting-notes`
- `generate-status-report`
- `jira-sprint-dashboard-canvas`

### SonarQube

Code quality in the agent loop. Reinstall the SonarQube plugin.

- `sonar-analyze`, `sonar-list-issues`, `sonar-list-projects`
- `sonar-quality-gate`, `sonar-coverage`, `sonar-duplication`
- `sonar-fix-issue`, `sonar-dependency-risks`, `sonar-integrate`

### PR Review Canvas

Renders PR diffs as a Cursor Canvas. Reinstall the **PR Review Canvas** plugin (`pr-review-canvas`).

## What is not included

- Cursor built-in skills (`%USERPROFILE%\.cursor\skills-cursor`) — come with Cursor
- Plugin skill *files* (Superpowers, Atlassian, SonarQube, PR Review Canvas) — reinstall the plugins above
- Company application source
