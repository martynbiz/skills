#!/usr/bin/env bash
#
# Symlink skills from this repo into Claude Code's skills directory.
#
# Usage:
#   ./install.sh                 Install all skills
#   ./install.sh grill-me ...    Install only the named skills
#   ./install.sh -u [names...]   Uninstall (remove symlinks) for all or named skills
#   ./install.sh -l              List skills and whether they are installed
#
# Set CLAUDE_DIR to target somewhere other than ~/.claude.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$REPO_DIR/skills"
DEST_DIR="${CLAUDE_DIR:-$HOME/.claude}/skills"

mode=install
case "${1:-}" in
  -u|--uninstall) mode=uninstall; shift ;;
  -l|--list)      mode=list; shift ;;
  -h|--help)      sed -n '3,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  -*)             echo "Unknown option: $1" >&2; exit 1 ;;
esac

# Skills to act on: named args, or every folder under skills/ with a SKILL.md
if [ $# -gt 0 ]; then
  names=("$@")
else
  names=()
  for dir in "$SRC_DIR"/*/; do
    [ -f "$dir/SKILL.md" ] && names+=("$(basename "$dir")")
  done
fi

if [ ${#names[@]} -eq 0 ]; then
  echo "No skills found in $SRC_DIR"
  exit 0
fi

mkdir -p "$DEST_DIR"
status=0

for name in "${names[@]}"; do
  src="$SRC_DIR/$name"
  dest="$DEST_DIR/$name"

  if [ ! -f "$src/SKILL.md" ]; then
    echo "✗ $name: no such skill in $SRC_DIR" >&2
    status=1
    continue
  fi

  case "$mode" in
    install)
      if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "· $name: already installed"
      elif [ -L "$dest" ]; then
        old="$(readlink "$dest")"
        ln -sfn "$src" "$dest"
        echo "↻ $name: relinked (was $old)"
      elif [ -e "$dest" ]; then
        echo "✗ $name: $dest exists and is not a symlink — skipping" >&2
        status=1
      else
        ln -s "$src" "$dest"
        echo "✓ $name: installed"
      fi
      ;;
    uninstall)
      if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        rm "$dest"
        echo "✓ $name: removed"
      elif [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "✗ $name: $dest is not a link to this repo — leaving it" >&2
        status=1
      else
        echo "· $name: not installed"
      fi
      ;;
    list)
      if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "✓ $name"
      else
        echo "  $name"
      fi
      ;;
  esac
done

exit $status
