# Update

Written for Arch, following the Arch Wiki's [System maintenance](https://wiki.archlinux.org/title/System_maintenance) page (revision 885170, retrieved 2026-10-19). On another distro, research its equivalent of each step first.

## Steps

1. **Read the news.** Find the last full upgrade: `grep 'starting full system upgrade' /var/log/pacman.log | tail -1`. Read every Arch News item since then (<https://archlinux.org/feeds/news/>). For each one that touches an installed package, stop, research what it requires, and fold that into the proposal.

2. **Preview.** List pending updates with `checkupdates` (from `pacman-contrib`), which does not sync the real database, and with the AUR helper's own preview. Flag:
   - fundamentals (kernel, systemd, glibc, mesa, the compositor or desktop, bootloader): search the forum for problems reported with the new version.
   - packages named as a trigger in `watchlist.md`.
   - changed AUR packages: read the PKGBUILD diff ([`../research.md`](../research.md) § Untrusted content).

3. **Timing.** Ask whether now is a good time. The wiki advises against upgrading right before an important task.

4. **Safety net.** Take a snapshot as `machine.md` describes, or say plainly that none is set up.

5. **Propose and hand over.** The upgrade is tier 2 and asks interactive questions, so the user runs it: `sudo pacman -Syu` for the repos, then the AUR helper. Always do a full upgrade, never a partial one (`-Sy` without `-u`).

6. **After.** Ask the user to paste the pacman output, or read it from `/var/log/pacman.log`. Then check:
   - alerts and notes printed by pacman: act on them now;
   - `.pacnew` / `.pacsave` files: `pacdiff -o` lists them; merging each one is its own proposal;
   - failed units: `systemctl --failed` and `systemctl --user --failed`, compared against before;
   - AUR packages needing a rebuild: `checkrebuild` if `rebuild-detector` is installed;
   - orphans: `pacman -Qtd`. Report them only; removing them is a separate proposal;
   - whether a reboot is needed (new kernel, systemd, or core libraries).

7. **Watchlist.** For every item whose trigger package was updated, run its check and tick or refresh it.

8. **Record.** Add a journal entry with the before → after versions of the fundamentals and anything deferred.

**Update is done** when the upgrade completed, every `.pacnew` is merged or recorded as deferred, failed units are unchanged or explained, triggered watchlist items are checked, and the journal entry is committed.
