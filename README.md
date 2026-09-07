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

## What is not included

- Cursor built-in skills (`%USERPROFILE%\.cursor\skills-cursor`)
- Plugin skills (Superpowers, Atlassian, SonarQube)
- Company application source
