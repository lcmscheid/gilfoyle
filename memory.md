# Memory

Gilfoyle's memory of one machine is a private git repo at `$GILFOYLE_HOME` (default `~/.local/share/gilfoyle`), created by `scripts/gilfoyle-init`. It never goes into the skill's repo. Push it only to a private remote.

Memory is a **cache of leads**, not ground truth. Before a change depends on a remembered fact, re-check the fact on the live system and refresh its `verified` date.

## Layout

```
$GILFOYLE_HOME/
├── MEMORY.md              index, read every run: machine one-liner, in progress, open questions
├── machine.md             facts about this machine: hardware, disks, boot, stack, safety net
├── preferences.md         the user's standing choices and taste (portable to a new machine)
├── watchlist.md           things to re-check when a trigger fires
├── gotchas.md             hard-won lessons: symptom → cause → fix, with sources
├── decisions/NNNN-slug.md decision records
├── journal/YYYY-MM.md     every change, append-only
├── notes/<topic>.md       research cache
└── facts/YYYY-MM-DD.md    raw output of scripts/gilfoyle-facts
```

Keep `MEMORY.md` short (about 60 lines): it is an index, so details belong in the files it points to.

## Formats

**Fact** (`machine.md`, `preferences.md`):
`- <fact> (verified YYYY-MM-DD via <command or source>)`

**Decision record** (`decisions/NNNN-slug.md`, copy `templates/decision.md`): context, the options weighed, what the user chose and why, sources, how to undo it, and when to revisit. `scope: portable` marks decisions that would carry over to another machine (taste, tool choices); `scope: machine` marks ones tied to this hardware. Once a decision is written it isn't rewritten: a new record supersedes it, and the old one gets `status: superseded by NNNN`.

**Journal entry** (`journal/YYYY-MM.md`, newest last):

```
## YYYY-MM-DD HH:MM — <title>   [tier N] [decision NNNN]
- Changed: <files, commands>
- Safety net: <backup path | snapshot id | none>
- Verified: <how>
- Undo: <exact commands>
- Status: applied | reverted YYYY-MM-DD
```

**Watchlist item** (`watchlist.md`):
`- [ ] <what> — trigger: <on update of pkg X | after date | upstream issue closes> — check: <how> — source: <link>`
The update and checkup flows walk the list and tick or refresh items.

**Gotcha** (`gotchas.md`): `### <symptom>`, followed by the cause, the fix, the source, and the version it was seen on.

## When to write

Write as soon as something is learned, not at the end: a session can stop at any point. Use the **in progress** section of `MEMORY.md` for multi-step work (the current step, the next step, any open proposal), so a later session can pick it up.

## Never store

Passwords, tokens, private keys, Wi-Fi passphrases, recovery keys. Record **where** a secret is kept ("LUKS recovery key: in the user's password manager"), never the secret itself. Scrub secrets out of log excerpts before saving them.

## Seeding from another machine

`scripts/gilfoyle-init --seed <other-memory-dir>` copies that machine's `preferences.md` and its `scope: portable` decisions into `seed/`. The setup flow walks through them with the user. Seeds are **leads** about taste, not facts about this hardware, so each one is re-confirmed and re-verified before it is applied.
