# Checkup

A read-only health check (tier 0) that ends in a report and, where needed, proposals. Skip any check whose tool isn't installed, and give the reason.

## Checks

| Check | How |
|---|---|
| Failed units | `systemctl --failed`, `systemctl --user --failed`; compare against known-harmless failures in `gotchas.md` |
| Errors this boot | `journalctl -b -p err --no-pager`: count them and group repeats |
| Disk space | `df -h`; on btrfs also `btrfs filesystem usage <mount>` |
| Filesystem health | btrfs: `btrfs device stats <mount>`, and the last scrub date (`btrfs scrub status <mount>`) |
| Drive health | `smartctl -H <dev>` needs root: hand the command to the user, or skip it |
| Updates | `checkupdates`, plus days since the last full upgrade (`/var/log/pacman.log`) |
| Arch News | items since the last upgrade (see [`update.md`](update.md) step 1) |
| Config merges | `pacdiff -o` |
| Orphans and foreign packages | `pacman -Qtd`, `pacman -Qm` |
| Safety net | age of the newest snapshot and the newest user-data backup, per `machine.md` |
| Firmware | `fwupdmgr get-updates`, if fwupd is installed |
| Watchlist | items whose trigger has fired or whose date has passed |
| Memory drift | spot-check five facts from `machine.md` against the live system |

## Report

One table: check, **OK / WARN / FAIL / SKIPPED**, and the evidence in a few words. Below it, one separate proposal per WARN and FAIL; the user picks which to act on. Add a one-line journal entry with the counts.

**Checkup is done** when every check has a status, every WARN or FAIL has a proposal or an explicit "leave it" from the user, and the journal line is committed.

Offer once to run checkups on a schedule (for example a user timer that runs `<skill>/scripts/gilfoyle-facts` and reports failures). That is itself a tier 1 proposal.
