# Setup: a new machine

Gilfoyle starts once the base OS boots, the network works, and an agent runs on it. The OS install itself (partitioning, encryption, bootloader) happens before that. If the user is still planning it, treat each install choice as a decision: research it, record it, and hand them the result to follow from the installer.

## Steps

1. **Create memory** (skip if Orient already did). Run `<skill>/scripts/gilfoyle-init`, adding `--seed <dir>` if the user has gilfoyle memory from another machine (see [`../memory.md`](../memory.md)).
   *Done when* `<skill>/scripts/gilfoyle-mem status` runs cleanly.

2. **Take stock.** Run `<skill>/scripts/gilfoyle-facts --save` (read-only, never uses sudo); it prints the file it wrote. Summarize it into `machine.md` as verified facts: hardware, GPU and driver, disks and filesystems, boot mode and loader, kernel, session and desktop, package counts. Flag anything odd: failed units, a missing microcode package, firmware that wants an update.
   *Done when* every section of `machine.md` is filled in or marked `unknown` with the reason.

3. **Interview.** Ask one topic at a time, and write the answers to `preferences.md`:
   - What is the machine for (work, gaming, development, family use)?
   - What stack do they want: compositor or desktop, shell, terminal, editor, browser, file manager?
   - What constraints apply: dual boot, laptop battery life, encryption, hardware that must work?
   - How cautious should gilfoyle be: stick close to stable defaults, or try newer things?
   - How do they want to be asked: one proposal at a time, or batches of related low-risk changes?

   If `seed/` exists, go through each seeded preference and decision: **keep**, **change**, or **drop**.
   *Done when* `preferences.md` covers every topic above, and every seed item has a verdict.

4. **Safety net first.** Before any tier 2 work, decide with the user how the system can be rolled back (filesystem snapshots, backups, both) and how user data is backed up. Research the options for this machine's filesystem and boot setup, propose, and record the decision. Then make sure recovery media exists (a live USB).
   *Done when* a rollback method is set up and tested once, recorded in `machine.md`, or the user has explicitly declined it (a decision record says so).

5. **Plan.** Turn the preferences into an ordered checklist under **in progress** in `MEMORY.md`. Order it by dependency: safety net → base health (microcode, firmware, GPU drivers, power management) → desktop stack → apps → dotfiles → user-data backups. Mark each item's tier. The user reorders, adds, or drops items.
   *Done when* the user has approved the checklist.

6. **Build.** Take one checklist item at a time through the **Change** flow in [`../SKILL.md`](../SKILL.md), ticking each item off as it completes. Re-run step 2 after major milestones so `machine.md` stays true.

7. **Finish.** Run [`checkup.md`](checkup.md).

**Setup is done** when every checklist item is done, dropped by the user, or moved to `watchlist.md`, and the checkup has no FAIL.
