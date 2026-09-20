#!/bin/sh
# chezmoi read-source-state hook: installs 1Password (app + CLI) right after
# `chezmoi init` clones this repo, before chezmoi reads any templates.
# Executed on EVERY source-state read, so it must exit immediately when
# there is nothing to do. See: chezmoi docs, "Install your password manager on init".

type op >/dev/null 2>&1 && exit 0

case "$(uname -s)" in
	Darwin)
		[ -x /opt/homebrew/bin/brew ] || exit 0
		exec /opt/homebrew/bin/brew install --cask 1password-cli@beta 1password@beta
		;;
esac
