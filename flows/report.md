# Report upstream

Read this only after a diagnosis shows a bug belongs to a specific project. Adapted from Omarchy's reporting guidance (<https://github.com/basecamp/omarchy>, `default/agents/skills/diagnose-crash/reporting.md`).

## Whose bug is it?

Be strict. A crash inside an application is that application's bug, not the distro's or the desktop's, unless their packaging or configuration is implicated. Name the project that owns the faulty code, and find where it takes reports (issue tracker, mailing list, distro bug tracker). If it isn't clear that this is a bug at all ("is this expected?"), the project's forum or chat is the place, not the tracker.

## Conditions, all required

1. The bug is **verified** on this machine, on current versions.
2. The user has seen the **exact** title and body and said yes. Gilfoyle never files unprompted.
3. The machine can file it (for GitHub: `gh auth status` succeeds). If it can't, don't install or authenticate anything: hand the user the finished text.

## Search first

Search the tracker for the program, the signal or error, and distinctive symbols, and include **closed** issues. A closed-as-fixed issue that still reproduces on the current release is a regression: report it there or link it.

If a match exists, read it fully. Add a comment only when you bring something new: a different reproduction, a symbolized stack, a narrower trigger, the version where it regressed. "Me too" is noise.

## Write it

What happened, what was expected, steps to reproduce, versions (`pacman -Qi <pkg>`, kernel, compositor), and the relevant log excerpt with secrets scrubbed. `gh` cannot attach media, so save screenshots and give the user the path to drag into the web form.

End with a line saying it was machine-authored: `Filed by <model> via <agent harness>.` If you aren't sure of your exact names, say so rather than inventing them.

Afterwards, add the issue link to the matching `watchlist.md` item.
