---
name: write-prd
description: Use when the user wants a written spec or PRD produced from a decision — typically right after a /grill-me session concludes, or when asked directly to "write this up as a spec/PRD", "turn this into a spec", "draft a PRD for X". Turns resolved decisions, assumptions, deferred items and risks into a structured spec document saved to the project.
---

# Write PRD

Turn a resolved discussion into a written spec/PRD. Most often this runs right after a `grill-me` session reaches its summary (Decisions / Assumptions / Deferred / Risks) — reuse that material rather than re-deriving it. It can also run standalone, directly from a request to spec something out.

## Before writing

- Pull Decisions, Assumptions, Deferred items and Risks from the conversation. If a `grill-me` session already happened, that's your source material — don't re-ask anything it already settled.
- If no grilling happened and real ambiguity remains (unresolved branches, contradictions, vague requirements), say so and suggest running `/grill-me` first. Proceed anyway if the user insists, or if the scope is simple enough that grilling would be overkill.
- Work out a filename: default to `specs/<kebab-case-title>.md` in the current project. Only ask if the project root or save location is genuinely unclear.

## Structure

Write a markdown document with these sections. Omit a section entirely if it's genuinely empty — don't pad with "N/A".

- **Title** + one-line summary
- **Context** — the problem or need this addresses, why now
- **Goals** — what success looks like
- **Non-goals** — explicitly deferred or out-of-scope items
- **Decisions** — the key choices made, each with a short rationale
- **Assumptions** — what's being relied on
- **Open questions / Risks** — unresolved concerns, flagged rather than guessed at
- **Verification** — how this will be tested or validated, if that was discussed

Write in British English (spelling and conventions) throughout.

## Output

Write the file. Show the user the path and a short summary of what's in it, and ask whether anything needs adjusting before moving to implementation (`/write-plan` can take it from here).

## Don't

- Don't re-ask questions the conversation already settled.
- Don't invent a decision that wasn't actually made — put it under Open questions instead of guessing.
- Don't start implementing.
