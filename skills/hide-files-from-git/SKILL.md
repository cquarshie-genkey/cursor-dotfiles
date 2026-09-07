---
name: hide-files-from-git
description: >-
  Hides paths from git status and commits machine-wide via the global Git
  excludes file (core.excludesfile). Never edits project .gitignore. Use when
  the user says hide certain files, hide from git, hide from commit and git,
  stop showing in git changes, or similar.
---

# Hide Files From Git (Global Excludes)

Hide paths so they do **not** appear in git changes on this machine. Do **not**
add them to any repository `.gitignore`.

## When to use

Apply when the user asks to hide files/folders from git/commits/changes, e.g.:

- "hide certain files"
- "hide X from commit and git"
- "stop showing X in git changes"
- "hide X globally"

## Hard rules

1. **Global excludes only** — append patterns to `git config --global core.excludesfile`.
2. **Never** edit project/repo `.gitignore` (or commit ignore changes) for this task.
3. **Never** print the full excludes file — only confirm the pattern was added/present.
4. Do not commit unless the user explicitly asks.

## Workflow

### 1. Resolve patterns

From the user request, produce one or more gitignore-style patterns:

| User intent | Pattern |
|-------------|---------|
| Directory (e.g. `.superpowers`) | `.superpowers/` |
| File (e.g. `notes.local.md`) | `notes.local.md` |
| Extension / glob | as given (e.g. `*.local`) |

Prefer directory form with trailing `/` when hiding a folder tree.

### 2. Resolve the global excludes file

```powershell
git config --global --get core.excludesfile
```

- If set: use that path.
- If unset: create `%USERPROFILE%\.gitconfig_global_excludes`, then:

```powershell
git config --global core.excludesfile "$env:USERPROFILE\.gitconfig_global_excludes"
```

Create the file if missing (empty is fine).

### 3. Append patterns (idempotent)

For each pattern, check only that line exists (do not dump the file):

```powershell
$excludes = (git config --global --get core.excludesfile)
$pattern = '.superpowers/'   # example
$escaped = [regex]::Escape($pattern)
$has = Select-String -Path $excludes -Pattern "^(\s*#.*)?$" -Quiet  # placeholder
$has = Select-String -Path $excludes -Pattern ("^\s*" + $escaped + "\s*$") -Quiet
if (-not $has) {
  Add-Content -Path $excludes -Value "`n$pattern" -Encoding utf8
}
```

Optional one-line comment above a new pattern is fine (e.g. `# Superpowers scratch`).

### 4. Unstage if already tracked/staged

In the current repo (and only if needed):

```powershell
git rm -r --cached -- <path>   # keeps working tree files
```

Skip if the path was never staged/tracked.

### 5. Verify

```powershell
git check-ignore -v -- <path>
git status --short -- <path>
```

Success: `check-ignore` matches via the global excludes file; `status` does not list the path as untracked/`A`/`M` for that hide target.

## What not to do

- Do not add patterns to repo `.gitignore`, `.git/info/exclude` (unless user asks for repo-only), or commit ignore churn.
- Do not delete the hidden files from disk.
- Do not unstage unrelated paths.
- Do not read aloud or paste unrelated existing exclude entries.

## Response

Briefly confirm:

- Patterns added (or already present)
- Global excludes file used (path only)
- That they no longer show in git changes
- That project `.gitignore` was not modified
