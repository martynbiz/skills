---
name: build-plan
description: Use when the user wants to implement a milestone from a /write-plan document — typically right after a plan is approved, or when asked directly to "build milestone X", "implement the plan", "start building". Builds one milestone (or an explicitly requested range), following its stated files, reuse and workflow (TDD or not), verifies it for real, marks it done in the plan, and stops for review before continuing.
---

# Build Plan

Turn an approved implementation plan (`write-plan`) into actual code, one milestone at a time, with a real review checkpoint between each one — the step after "what we're building and in what order" and before the work is considered finished.

## Before building

- Pull the plan: read the plan file in full (the one `write-plan` just wrote, or the one the user points to). If no plan file exists, say so and suggest `/write-plan` (and further back, `/grill-me` → `/write-prd`) first — building without a plan loses the milestone structure, file list, and Stack/workflow decisions this skill depends on. Proceed anyway if the user insists, or the work is trivial enough that a plan would be overkill.
- Find the next undone milestone: each milestone heading carries a checkbox (`### N. [ ] Title` → `[x]` once built). Treat the first unchecked one as the starting point. If none are checked yet, start at Milestone 1.
- Confirm scope for this run: **default to exactly one milestone.** If the user names a specific milestone or an explicit range ("do milestones 2 and 3"), build only that — never silently continue further just because the next milestone looks small or related.

## How to build a milestone

- Follow the plan's recorded **Stack** and **workflow** exactly:
  - If the plan recorded **incremental TDD**: work through the milestone's listed files function-by-function (or behaviour-by-behaviour) — write a failing test for the next piece, implement just enough to pass it, refactor, then move on. Don't write all the milestone's production code first and backfill tests afterward.
  - If the plan recorded **no TDD**: implement the milestone's files, then add tests per what the milestone describes.
- Build only the files the milestone lists, reusing what it says to reuse. If something doesn't fit as planned — a wrong assumption surfaces, a dependency doesn't support what was planned, an "Open question carried forward" turns out to actually block this milestone — stop and tell the user rather than quietly improvising a different approach.
- Run the milestone's own stated **Verify** step for real (run the actual command, test suite, or manual check it describes). "The code looks right" is not verification.

## Output

- Once verification genuinely passes, flip that milestone's checkbox to `[x]` in the plan file, then summarize what was built and how it was verified.
- Stop there. Don't continue to the next milestone unless the user explicitly asked for more than one this run.
- Don't commit automatically — git commits require the user's explicit go-ahead each time, per standing policy. Summarize the diff and suggest reviewing/committing it; only commit if the user says so this run.
- At the end of a milestone, decide what's actually worth recommending rather than generically listing both options every time:
  - Recommend `/security-review` when this milestone touched authentication/access control, secrets or credential handling, or untrusted external input (e.g. a webhook/API endpoint, anything parsing freeform input into an action) — say briefly why, not just that it exists. Reviewing before committing means any fixes land in the same commit rather than a follow-up one.
  - Recommend `/code-review` when this milestone introduced non-trivial logic or branching worth a second look.
  - For a milestone that's pure scaffolding/config with no real logic (already fully covered by its passing tests), say neither is needed rather than suggesting them out of habit.
  - Never run either unasked — recommend, then wait.

Write in British English (spelling and conventions) throughout.

## Don't

- Don't skip a milestone's stated verification step.
- Don't silently build past the requested scope (one milestone by default), even if later ones look trivial or related.
- Don't commit automatically.
- Don't quietly deviate from the plan's file list, Stack, or workflow choice (TDD or not) — if something doesn't fit, stop and ask rather than improvising.
- Don't re-plan from scratch if the plan itself looks wrong — say so and suggest revisiting `/write-plan`, don't just build something different instead.
