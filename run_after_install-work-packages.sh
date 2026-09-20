#!/bin/sh
# Layer work packages on top of the personal Brewfile when the work repo
# provides one at ~/.config/work/homebrew/Brewfile. Runs on every apply but
# only invokes brew bundle when the work Brewfile's content has changed
# (chezmoi cannot hash external-repo files at template time, so the check
# happens here, at runtime).

set -e

WORK_BREWFILE="${HOME}/.config/work/homebrew/Brewfile"
[ -f "$WORK_BREWFILE" ] || exit 0

BREW=/opt/homebrew/bin/brew
[ -x "$BREW" ] || BREW=$(command -v brew 2>/dev/null || true)
[ -n "$BREW" ] || exit 0

HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_AUTO_UPDATE

STATE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/chezmoi"
STATE_FILE="${STATE_DIR}/work-brewfile.sha256"
mkdir -p "$STATE_DIR"

hash=$(shasum -a 256 "$WORK_BREWFILE" | cut -d ' ' -f 1)

if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "$hash" ]; then
	exit 0
fi

"$BREW" bundle install --no-upgrade --file "$WORK_BREWFILE"
printf '%s\n' "$hash" > "$STATE_FILE"
