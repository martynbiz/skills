# Skills

A personal collection of AI skills, plugins, agents and related tooling — mostly for [Claude Code](https://claude.com/claude-code), but anything reusable for working with AI lives here.

## Layout

```
skills/      # Standalone skills — each in its own folder with a SKILL.md
plugins/     # Plugins bundling skills, slash commands, agents and hooks
agents/      # Subagent definitions (.md with frontmatter)
commands/    # Slash commands
hooks/       # Hook scripts and settings snippets
```

Folders get added as things land in them.

## Skills

Each skill is a folder containing a `SKILL.md` with YAML frontmatter:

```markdown
---
name: my-skill
description: Use when … (this is what decides when the skill triggers, so be specific)
---

Instructions for Claude go here.
```

Supporting files (references, scripts, templates) can sit alongside `SKILL.md` and be referenced from it.

| Skill | Description | Example |
|-------|-------------|---------|
| [grill-me](skills/grill-me/SKILL.md) | Relentlessly interviews you about a plan or design, one question at a time, until every decision is resolved. | `/grill-me I want to migrate our course pages from Drupal to a headless CMS` |

## Plugins

| Plugin | Description |
|--------|-------------|
| _none yet_ | |

## Installing

**Skills** — run the install script, which symlinks each skill into `~/.claude/skills/` (so edits here are picked up immediately):

```bash
./install.sh                # install all skills
./install.sh grill-me       # install specific skills
./install.sh -l             # list skills and install status
./install.sh -u [names...]  # uninstall (removes only symlinks pointing at this repo)
```

It's safe to re-run, and it won't overwrite a skill folder you've installed some other way. Set `CLAUDE_DIR` to install somewhere other than `~/.claude`. Run `/reload-skills` (or start a new session) afterwards.

**A plugin** — add this repo as a marketplace, then install from it inside Claude Code:

```
/plugin marketplace add <path-or-git-url-to-this-repo>
/plugin install <plugin-name>
```

## Adding something new

1. Create a folder under the relevant directory.
2. Write the `SKILL.md` (or agent/command file) — keep the `description` focused on *when* to use it.
3. Try it out locally.
4. Add a row to the table above.
