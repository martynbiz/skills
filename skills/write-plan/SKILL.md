---
name: write-plan
description: Use when the user wants a concrete implementation plan produced from a resolved spec/PRD — typically right after a /write-prd document is saved, or when asked directly to "plan the implementation", "turn this spec into a plan", "break this into tasks/milestones". Turns a PRD's Decisions into an ordered, file-level plan for building it.
---

# Write Plan

Turn a written spec/PRD into a concrete, file-level implementation plan — the step between "what we decided" (`write-prd`) and writing code. Most often runs right after `/write-prd` saves a spec. Can also run standalone, directly from a request to plan out a known piece of work.

## Before planning

- Pull the PRD: read the spec file in full (the one `write-prd` just wrote, or the one the user points to). Decisions are fixed constraints, not re-litigated. Non-goals stay out of scope. Open questions/Risks get surfaced, not silently resolved.
- If no PRD exists and real design ambiguity remains, say so and suggest `/grill-me` (then `/write-prd`) first — planning concrete files against an unresolved design just encodes the ambiguity into code. Proceed anyway if the user insists, or the scope is simple enough that a PRD would be overkill.
- Explore the actual codebase before writing anything: find the existing files, modules, and patterns each Decision would touch or could reuse. A plan that invents new structure where a reusable pattern already exists is wrong, not just inefficient.
- **If the project is empty or has no established stack** (no language/framework/package files to infer from), the PRD's Decisions almost never cover implementation-level choices — those are what make milestones concrete (a "file" isn't a thing yet without them). Ask the user directly, in one batched round of questions (several questions in a single turn, not several back-and-forth turns), for enough of these to write real paths and real commands:
  - Target language/runtime.
  - Each framework/library the PRD's Decisions actually imply a need for (e.g. a webhook framework, a scheduler/cron library) — ask these **as their own choices**, not folded silently into a single "pick a stack" bundle. Picking a language doesn't imply a specific framework; don't assume one on the user's behalf.
  - Package manager and test runner.
  - Development workflow preferences that change how milestones get built and verified — most importantly, **incremental TDD** (for each small piece of behavior: write a failing test, implement just enough to pass it, refactor, then move to the next) **vs. no TDD** (implement first, add tests alongside or afterward). Present both as genuinely valid choices — don't default to assuming either. Do not offer "write the entire test suite up front, then implement everything" as an option; that isn't how TDD is practiced and isn't a reasonable alternative to include.
  - **How this actually reaches production, when a PRD Decision references existing infrastructure at a high level** (e.g. "deploy to my VPS", "use my existing reverse proxy/Let's Encrypt setup") without the mechanics. Ask what's actually there — reverse proxy software, shared Docker network, routing/subdomain convention, Compose vs. a bare Dockerfile — rather than inventing a plausible-sounding generic setup. A high-level Decision being settled doesn't mean its implementation mechanics are.
  - Whether there's anything else about how they want this built (conventions, tooling, CI, other constraints) before the plan is locked in.

  Keep this to one round-trip, not a full `/grill-me` pass — this is filling in missing scaffolding, not re-opening the design — but don't compress independent decisions into a small number of take-it-or-leave-it presets just to save a question. A genuinely linked pair (e.g. a framework that only makes sense with one specific companion library) can be offered together; unrelated axes (framework choice, package manager, test runner, workflow) must not be bundled behind a single label like "the Node stack." Record the answers as a **Stack** entry in the plan's Context section so they're not asked again on a later run.
- Work out a filename: default to `specs/<kebab-case-title>-plan.md` (same title as the source PRD, suffixed `-plan`) in the current project. Only ask if the location is genuinely unclear.

## Structure

Write a markdown document with these sections. Omit a section entirely if it's genuinely empty — don't pad with "N/A".

- **Title** + one-line summary, referencing the source PRD by path
- **Context** — carried from the PRD, not re-derived; if the project was empty, include the **Stack** choices gathered during planning (language/runtime, frameworks, package manager, test runner, workflow/TDD preference) so they aren't re-asked next time
- **Milestones** — ordered phases of work; each one states what it delivers, the specific files/modules it touches (real paths found during exploration, not placeholders), what existing code it reuses, its dependency on earlier milestones, and how to verify it before moving to the next one. When incremental TDD was chosen, a milestone's files are built up function-by-function (or behavior-by-behavior): write a failing test for the next small piece, implement just enough to pass, refactor, repeat — not one test for the whole milestone followed by one big implementation pass.
- **Open questions carried forward** — anything the PRD flagged as unresolved that actually blocks a milestone, raised here rather than guessed at
- **Out of scope** — Non-goals from the PRD, restated so they aren't accidentally picked back up mid-build

Write in British English (spelling and conventions) throughout.

## Output

Write the file. Show the user the path and a short summary of the milestones, and ask whether anything needs adjusting before starting on the first one.

## Don't

- Don't re-litigate Decisions already made in the PRD — if one looks wrong, say so explicitly and ask, don't quietly plan around a different choice.
- Don't invent file/module structure without checking what already exists in the codebase.
- Don't start writing implementation code — this skill ends at an approved plan.
- Don't enumerate every file for a repeated pattern — describe the pattern once and give a couple of representative paths.
- Don't bundle independent implementation choices (framework, package manager, test runner, workflow) into a single preset the user can only accept or reject as a whole — ask each axis separately so they can swap out just one piece.
- Don't invent plausible-sounding specifics for infrastructure the PRD only references at a high level (e.g. "my VPS", "my existing reverse proxy/Let's Encrypt setup") — ask what's actually there rather than assuming a generic/typical setup.
