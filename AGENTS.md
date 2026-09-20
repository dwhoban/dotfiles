# AGENTS.md

Chezmoi source state for my dotfiles. This directory IS the chezmoi source
(`~/.local/share/chezmoi`, symlinked from `~/Workspace/projects/dotfiles`);
everything managed here deploys into `$HOME` on `chezmoi apply`.
Remote: `github.com/dwhoban/dotfiles` (SSH), branch `main`.
Toolchain: Homebrew 7.x at `/opt/homebrew` (Apple Silicon macOS), chezmoi 2.72+ via Homebrew.

## Homebrew / Brewfile workflow

- The personal Brewfile is `homebrew/Brewfile` in this repo (ignored as a
  target). `dot_config/homebrew/symlink_Brewfile.tmpl` deploys it as a
  symlink at `~/.config/homebrew/Brewfile` — Homebrew 7's global Brewfile
  location — so brew tools edit the repo file directly.
- Adding a package: `brew bundle add <pkg>` (writes through the symlink);
  the `run_onchange_after_install-brew-packages.sh.tmpl` re-runs
  `brew bundle install --no-upgrade` on the next apply because its content
  embeds the Brewfile's SHA256.
- `brew bundle dump --global --force` replaces the file with the machine's
  installed state and gets auto-committed. Only meaningful on personal
  machines; it also resets the global trust store (see below).
- Third-party tap entries need `trusted: true` (Homebrew 7 tap trust is
  mandatory; the attribute persists into `~/.config/homebrew/trust.json`).
  Never run `brew bundle cleanup --force` against the personal Brewfile on a
  work machine — it would wipe work-tap trust entries.
- Work machines layer a second Brewfile from the work repo clone at
  `~/.config/work/homebrew/Brewfile`, applied by
  `run_after_install-work-packages.sh` (runtime content-hash gated).
- Fresh-machine bootstrap: `install-init-shell.sh` installs Homebrew
  (official installer, guarded) before `chezmoi init --apply`; a
  `read-source-state.pre` hook (`.install-password-manager.sh`) installs the
  1Password app + CLI casks before any template runs.
