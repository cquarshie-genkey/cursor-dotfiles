---
name: start-work-jira
description: >-
  Starts local work on a Jira story: fetch the issue once, create a branch,
  discover repo conventions, explore the codebase, and produce an implementation
  plan (no code until approved). Use when the user says "start work on GKE-XXXX"
  or similar (e.g. start work on a Jira ticket / story / issue key).
---

# Start Work on a Jira Story

When the user says "start work on [issue key]" (e.g. `GKE-1292`), follow these steps in order without stopping to ask unless genuinely blocked.

Announce: "Using start-work-jira to set up work on [issue key]."

## 1. Fetch the issue (single Atlassian call)

Use the Atlassian MCP **once** to fetch the full issue:
- Cloud ID: `e19515c8-40c4-4a9e-b209-6b4b63d3b8e9`
- Tool: `getJiraIssue` with the provided issue key
- Extract: summary, description, and acceptance criteria (look for an "Acceptance Criteria" section in the description)

**Do not make any other Atlassian MCP calls** after this step — no Confluence lookups, no related-issue searches, no comments, no JQL, no `search`, no `getConfluencePage`. Generate the plan from the fetched issue plus local codebase exploration only.

## 2. Create a branch

Default base is `main`:

```
git fetch origin main
git checkout main
git pull origin main
git checkout -b "{issueKey}-{kebab-slug-of-summary}"
```

If the user specifies a different base branch (e.g. another feature branch), branch from that instead of `main`.

Follow the existing convention: `GKE-1292-Implement-passport-reprinting-request-validations`. Spaces become hyphens, keep it under 80 chars.

## 3. Discover the repo's conventions

Before exploring any feature code, orient yourself to the current repository:
- Read all `.cursor/rules/*.mdc` files in this workspace — these define the authoritative conventions for this project
- Check for `docs/ARCHITECTURE.md`, `README.md`, or `CONTRIBUTING.md` for structural and layering guidance
- Note the root folder structure to understand module/package boundaries

Use what you find to guide all exploration and planning decisions below.

## 4. Explore the codebase

Identify all files relevant to the acceptance criteria, guided by the conventions discovered in step 3.
Search for existing patterns similar to what the story requires before planning anything new.

## 5. Generate an implementation plan — STOP, do not write any code

**You must not write, edit, or create any code or files at this step.**

Produce a structured implementation plan and present it to the user. The plan must cover:
- A brief summary of what the story requires
- Affected files and folders, with a one-line description of the change needed in each
- Proposed implementation order (e.g. data layer → service → use case → view)
- Any open questions or risks that need clarification before coding begins

After presenting the plan, ask the user explicitly: "Does this plan look correct? Say yes to proceed with implementation."

**Do not proceed further until the user gives explicit approval.** If the user approves, only then begin implementing the plan.
