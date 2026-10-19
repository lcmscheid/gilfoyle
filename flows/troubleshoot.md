# Troubleshoot

Work from evidence. The goal is an honest account of what happened, not a story that sounds plausible. Diagnosis is tier 0: it reads, and leaves the system as it found it. The fix goes through **Change**.

## Steps

1. **Pin the symptom** with the user: what exactly happens, since when, how often, whether it reproduces on demand, and what changed around then.

2. **Check memory.** Look in `gotchas.md`, `watchlist.md`, and the journal entries around the onset. A match is a **lead**: confirm it still applies.

3. **Collect evidence** (always with `--no-pager`):
   - `journalctl -b -p warning` (add `--user`, `-u <unit>`, or `--since` to narrow it);
   - `systemctl --failed`, and the same with `--user`;
   - `/var/log/pacman.log` for updates near the onset;
   - `find ~/.config /etc -newermt '<onset>' -type f 2>/dev/null` for config files touched around then;
   - `coredumpctl list` for crashes (see below).

4. **Rule out the boring causes**: a full disk, an OOM kill, a partial upgrade, an unmerged `.pacnew`, a pending reboot after a kernel update.

5. **Hypotheses.** List the candidates, each with a read-only test that would confirm or kill it. Run the tests. Search the exact error strings with [`../research.md`](../research.md).

6. **Report** what the evidence **proves**, separately from what you **infer**. Then do one of:
   - propose the fix at the right layer (**Change**);
   - for an upstream bug: propose a workaround, add a `watchlist.md` item that triggers on the fixing release, and offer [`report.md`](report.md);
   - if it is still unclear: say so, and say what evidence would settle it (for example, "run this when it happens next").

7. **Record** a `gotchas.md` entry once the cause is confirmed.

**Troubleshoot is done** when the cause is verified, or labelled a hypothesis with the test that would prove it; any fix has gone through **Change** and the original symptom no longer reproduces; and the gotcha is recorded.

## Crashes

- `coredumpctl info <pid>`: read beyond the backtrace. The **command line** often says what the program was working on when it died.
- `coredumpctl list`: a one-off, or a pattern? Several programs dying together point somewhere else (a shared library, the GPU, memory).
- Look at all the threads, not just the one that crashed: what was in flight explains the trigger.
- Symbolize with Arch's debuginfod (<https://debuginfod.archlinux.org>):

  ```bash
  core=$(mktemp -t crash-XXXXXX.core)
  coredumpctl dump <pid> --output="$core"
  DEBUGINFOD_URLS="https://debuginfod.archlinux.org" gdb -q <executable> "$core" -batch -ex 'set debuginfod enabled on' -ex 'thread apply all bt'
  rm -f "$core"
  ```

  A core is a copy of the process's memory and can hold passwords and private documents: keep it in a fresh `mktemp` file and delete it when done. Frames that stay unresolved are reported as unresolved; never invent function names to fill the gap.

Crash method adapted from Omarchy's `diagnose-crash` skill (<https://github.com/basecamp/omarchy>, `default/agents/skills/diagnose-crash`).
