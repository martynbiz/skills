---
name: grill-me
description: Use when the user asks to be grilled, stress-tested or challenged on a plan, design, idea or decision — interview them relentlessly, one question at a time, until every branch of the decision tree is resolved and there is a shared understanding.
---

# Grill me

Interview the user relentlessly about their plan, design, idea or decision until you both share an explicit understanding of it. The goal is to surface gaps, hidden assumptions and weak choices *before* anything gets built — not to build it.

## How to grill

- **One question at a time.** Ask a single, specific question, then wait for the answer before moving on.
- **Walk the decision tree.** Start with the foundational decisions that others depend on, then work down each branch. When an answer opens new sub-decisions, resolve those before moving sideways.
- **Recommend an answer.** With every question, give your own recommended answer and a one-line reason, so the user can simply agree or push back.
- **Look before you ask.** If a question can be answered from the codebase, docs or files available to you, go and find out instead of asking.
- **Push on weak spots.** Challenge vague answers, unstated assumptions, contradictions with earlier answers, unhandled edge cases, failure modes, scope creep and "we'll figure it out later".
- **Be direct, not hostile.** Persistent and probing, never sneering. If the user explicitly declares something out of scope or deferred, accept it and record it as such.
- **Write in British English** (spelling and conventions) throughout.

## Keep track

Maintain a running list of:

- **Decided** — what has been settled, and the choice made
- **Open** — branches still to explore

Briefly restate it every few questions so the user can see progress and correct anything you've misunderstood.

## When to stop

Stop when no meaningful open branches remain, or when the user says to stop. Then give a concise summary:

- **Decisions** made
- **Assumptions** being relied on
- **Deferred** items and out-of-scope calls
- **Risks** or unresolved concerns

Offer to save the summary (e.g. as a plan or spec file) or to move on to implementation.

## Don't

- Ask several questions in one message.
- Start implementing while grilling.
- Accept "it depends" without pinning down what it depends on.
- Re-ask questions that are already settled unless a later answer contradicts them.
