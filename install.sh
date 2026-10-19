#!/usr/bin/env bash
# Link this skill into the skill directory of every agent harness found on this machine.
# Safe to re-run. Directory list follows the Omarchy manual (manual/17-ai.md).
set -euo pipefail

src=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
chmod +x "$src/scripts/"*

# "<harness home>:<its skills dir>" — a skills dir is used only if its harness is installed.
targets=(
  "$HOME/.agents:$HOME/.agents/skills"
  "$HOME/.claude:$HOME/.claude/skills"
  "$HOME/.codex:$HOME/.codex/skills"
  "$HOME/.pi/agent:$HOME/.pi/agent/skills"
)

declare -A done_dirs=()
linked=0
for t in "${targets[@]}"; do
  harness=${t%%:*} dir=${t#*:}
  [[ -d $harness ]] || continue
  mkdir -p "$dir"
  real=$(readlink -f "$dir")
  [[ -n ${done_dirs[$real]:-} ]] && continue   # e.g. ~/.claude/skills -> ~/.agents/skills
  done_dirs[$real]=1
  link="$dir/gilfoyle"
  if [[ -L $link ]]; then
    ln -sfn "$src" "$link"; echo "updated $link"
  elif [[ -e $link ]]; then
    echo "skipped $link: exists and is not a symlink" >&2; continue
  else
    ln -s "$src" "$link"; echo "linked  $link"
  fi
  linked=$((linked + 1))
done

if (( linked == 0 )); then
  echo "No agent harness found (looked for ~/.agents, ~/.claude, ~/.codex, ~/.pi/agent)." >&2
  echo "Install one, or link manually: ln -s $src <skills-dir>/gilfoyle" >&2
  exit 1
fi
echo "Done. Start your agent and say: \"gilfoyle, set up this machine\"."
