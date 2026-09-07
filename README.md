# cursor-dotfiles

Backup of machine-local Cursor skills, rules, hooks, and the shared GenKey troubleshooting log. These files are not tracked in company repos (user-level Cursor config, or gitignored `.cursor/` folders).

Remote: https://github.com/cquarshie-genkey/cursor-dotfiles

## Custom skills (this repo)

User-level skills. Restore to `%USERPROFILE%\.cursor\skills\`.

| Skill | When to use | What it does |
|---|---|---|
| [`start-work-jira`](skills/start-work-jira/SKILL.md) | “Start work on GKE-1199” (or any issue key) | Fetches the Jira issue once, creates a branch from `main`, reads repo conventions, explores the code, then writes a plan. Does not implement until you approve. |
| [`hide-files-from-git`](skills/hide-files-from-git/SKILL.md) | “Hide this from git” / stop it showing in changes | Adds a pattern to the **global** Git excludes file. Never edits a project `.gitignore`. |
| [`generate-voter-roll-sample-data`](skills/generate-voter-roll-sample-data/SKILL.md) | Sample voter-roll / confirmation-list / PDF test data | Temporarily pads EOD or ZEC electoral-list DTOs from the first real record. Must be removed before commit. |

## Custom rules (this repo)

### Always-on (user)

Restore to `%USERPROFILE%\.cursor\rules\`.

| Rule | What it does |
|---|---|
| [`no-ai-commit-credit`](user-rules/no-ai-commit-credit.mdc) | Commits stay in your name only. No `Co-authored-by` / agent credit trailers. |
| [`clear-superpowers-sdd-on-complete`](user-rules/clear-superpowers-sdd-on-complete.mdc) | After a finished task, delete Superpowers SDD scratch under `.superpowers/sdd/`. Paired with [`hooks/clear-superpowers-sdd.ps1`](hooks/clear-superpowers-sdd.ps1) on stop / session end. |

### Shared across GenKey projects

Restore to `C:\dev\genkey projects\.cursor\`.

| Rule / file | What it does |
|---|---|
| [`TROUBLESHOOTING.local.md`](genkey-projects/TROUBLESHOOTING.local.md) | Living log of local startup/env fixes (excluded from company git). |
| [`local-troubleshooting-log`](genkey-projects/rules/local-troubleshooting-log.mdc) | Check that log before treating a deploy/startup error as an app bug; append new fixes. |
| [`meaningful-naming`](genkey-projects/rules/meaningful-naming.mdc) | Prefer domain names over borrowed jargon (open/view, not drill/hydrate). |
| [`spire-consoles-conventions`](genkey-projects/rules/spire-consoles-conventions.mdc) | Consoles architecture: views / use cases / services / components; follow existing patterns. |

### Spire Consoles (gitignored in that repo)

Restore to `C:\dev\genkey projects\spire-consoles\.cursor\rules\`. Already present in that project; do not put these in the shared GenKey `.cursor\rules` folder.

| Rule | What it does |
|---|---|
| [`use-case-patterns`](spire-consoles-rules/use-case-patterns.mdc) | Kotlin `*UseCase` files: co-locate related use cases, keep services as API adapters. Applies to `**/*UseCase.kt`. |

### Spire UI (gitignored in that repo)

Restore to `C:\dev\genkey projects\spire-ui\.cursor\rules\`.

| Rule | What it does |
|---|---|
| [`spire-ui-conventions`](spire-ui-rules/spire-ui-conventions.mdc) | Spring MVC + Thymeleaf modules: skip `pom.xml` when exploring, extend existing search/list flows, don’t parallel-copy. |
| [`ask-before-implementing-alternatives`](spire-ui-rules/ask-before-implementing-alternatives.mdc) | If a config/CSV/data fix might beat code, stop and ask which approach you want. |
| [`spire-ui-pr-review`](spire-ui-rules/spire-ui-pr-review.mdc) | On “review this”: security, Bugbot, then conventions (reuse vs parallel paths, role NPEs, regressions). |

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
| `spire-consoles-rules\*.mdc` | `C:\dev\genkey projects\spire-consoles\.cursor\rules\` |

Optional: also copy `genkey-projects\rules\spire-consoles-conventions.mdc` into `C:\dev\genkey projects\spire-consoles\.cursor\rules\` if you want the project-local copy.

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
New-Item -ItemType Directory -Force -Path "C:\dev\genkey projects\spire-consoles\.cursor\rules" | Out-Null
Copy-Item "$src\spire-consoles-rules\*" "C:\dev\genkey projects\spire-consoles\.cursor\rules\" -Force
```

## Installed Cursor plugins (reinstall; not copied here)

These come back by installing the plugin in Cursor. They are not backed up as files in this repo.

### Superpowers (obra / cursor-public)

Agent workflow skills. Reinstall the Superpowers plugin after a reset.

- `using-superpowers` — check and follow the right skill before any other action
- `brainstorming` — explore intent and design before building a feature
- `writing-plans` — turn a spec into a multi-step implementation plan
- `executing-plans` — run a written plan in a later session with review checkpoints
- `subagent-driven-development` — implement independent plan tasks via subagents
- `dispatching-parallel-agents` — split work that has no shared state
- `systematic-debugging` — find root cause before proposing a fix
- `test-driven-development` — failing test first, then implementation
- `verification-before-completion` — prove it works before claiming done
- `requesting-code-review` — ask for review before merge
- `receiving-code-review` — treat review comments rigorously, not performatively
- `finishing-a-development-branch` — choose merge, PR, or cleanup when work is done
- `using-git-worktrees` — isolated workspace before feature work or plan execution
- `writing-skills` — author or verify a new skill

### Atlassian (Claude / MCP skills)

Jira and Confluence. Reinstall the Atlassian plugin and sign in.

- `search-company-knowledge` — look up internal docs, processes, and terminology
- `triage-issue` — search Jira for duplicates and draft a bug ticket
- `spec-to-backlog` — turn a Confluence spec into epics and implementation tickets
- `capture-tasks-from-meeting-notes` — extract action items and create Jira work
- `generate-status-report` — summarize Jira progress, optionally publish to Confluence
- `jira-sprint-dashboard-canvas` — visual sprint / standup dashboard from Jira data

### SonarQube

Code quality in the agent loop. Reinstall the SonarQube plugin.

- `sonar-analyze` — quality and security issues for a file or snippet
- `sonar-list-issues` — search and filter project issues
- `sonar-list-projects` — projects the current user can access
- `sonar-quality-gate` — pass/fail gate and each condition
- `sonar-coverage` — low-coverage files and uncovered lines
- `sonar-duplication` — duplication blocks for a file
- `sonar-fix-issue` — fix one issue by rule key and location
- `sonar-dependency-risks` — SCA / composition risks
- `sonar-integrate` — install CLI, authenticate, and wire analysis hooks

### PR Review Canvas

Renders PR diffs as a Cursor Canvas. Reinstall the **PR Review Canvas** plugin (`pr-review-canvas`).

## What is not included

- Cursor built-in skills (`%USERPROFILE%\.cursor\skills-cursor`) — come with Cursor
- Plugin skill *files* (Superpowers, Atlassian, SonarQube, PR Review Canvas) — reinstall the plugins above
- Company application source
