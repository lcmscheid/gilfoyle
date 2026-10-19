# gilfoyle

An agent skill that looks after a Linux PC **together with you**. It works with Claude Code, Codex, Pi, and any harness that reads `~/.agents/skills`.

Gilfoyle is built on three rules:

- **It checks, it doesn't guess.** Every claim comes from the live system or a source: man pages, `--help`, the Arch Wiki, upstream docs and issue trackers, then forums. Each claim is labelled *verified*, *sourced*, or *hypothesis*. The model's training and gilfoyle's own notes are only leads.
- **You decide.** Gilfoyle investigates freely, but every change arrives as a proposal: why, sources, options, exact commands, safety net, undo, and a risk tier. Nothing runs until you say yes. Privileged commands are handed to you to run.
- **It remembers.** Each machine gets its own private memory: facts, decision records, a change journal with undo lines, gotchas, and a watchlist of upstream bugs to re-check. That makes "why is this set up like this?" and "undo that" answerable months later.

Primary target: Arch Linux. The flows cite Arch tooling (pacman, Arch News, the AUR); on other distros gilfoyle researches the equivalent first.

## Install

```bash
git clone https://github.com/<you>/gilfoyle ~/projects/gilfoyle_skill
~/projects/gilfoyle_skill/install.sh
```

`install.sh` symlinks the skill into each harness's skill directory it finds (`~/.agents/skills`, `~/.claude/skills`, `~/.codex/skills`, `~/.pi/agent/skills`), skipping duplicates. It is safe to re-run.

Then start your agent and say **"gilfoyle, set up this machine"**.

## What you can ask

| Say | Gilfoyle does |
|---|---|
| "set up this machine" | creates memory, takes stock of the hardware, interviews you, puts a safety net in place first, then builds your stack from a checklist |
| "change / install / enable X" | finds which file or tool owns the setting, researches, proposes, backs up, applies, verifies, records |
| "update the system" | reads Arch News since your last update, previews, checks the forums for fundamentals, hands you the upgrade, then handles `.pacnew` files, failed units, rebuilds, and the watchlist |
| "X is broken" / "why did X crash" | collects evidence, rules out the boring causes, tests hypotheses, keeps what's proven separate from what's guessed |
| "checkup" | read-only health report (units, logs, disks, btrfs, updates, snapshots, firmware, watchlist, memory drift) with one proposal per problem |
| "why is X like this?" | answers from its decision records, then checks the system still matches |
| "undo that" | turns the journal's undo line into a proposal |
| "report this upstream" | searches existing issues, drafts the report, files it only with your yes |

## Memory

Memory is **not** stored in this repo. Each machine's memory is its own git repo at `$GILFOYLE_HOME` (default `~/.local/share/gilfoyle`), so it contains your hardware, paths, and logs and nothing else. Every memory change is a commit. Push it only to a **private** remote if you want a backup. Gilfoyle never writes secrets into memory, only where they are kept.

Moving to a new PC? `scripts/gilfoyle-init --seed <old-memory-dir>` brings over your preferences and portable decisions as suggestions, which gilfoyle re-confirms with you and re-verifies against the new hardware.

## Layout

```
SKILL.md                core: orient, risk tiers, proposals, change / recall / undo, close
research.md             source ladder, claim labels, citations, untrusted content
memory.md               memory layout and formats
flows/                  setup, update, troubleshoot, checkup, report
templates/              new-memory skeleton and the decision-record template
scripts/gilfoyle-init   create a machine's memory repo (optionally seeded)
scripts/gilfoyle-facts  read-only machine snapshot as Markdown
install.sh              link the skill into every installed harness
```

## Credits

Inspired by the [Omarchy](https://github.com/basecamp/omarchy) skills (`default/agents/skills/`) and [robzolkos/omarchy-skill](https://github.com/robzolkos/omarchy-skill): the read-only-defaults-vs-user-config ownership line, privilege handling, evidence-first crash diagnosis, and strict upstream reporting.

## License

MIT
