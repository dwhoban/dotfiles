# Work repo contract

Requirements for the work dotfiles repo (`work-dotfiles`, default remote
`git@github.com:dwhoban/work-dotfiles.git`). This document is the source of
truth for what that repo must contain; it lives in the personal dotfiles
repo and is ignored as a chezmoi target.

## Clone contract

- `.chezmoiexternal.toml` (personal repo) clones the work repo to
  `~/.config/work` on machines where `work = true` in the chezmoi config.
- Refresh is manual: `chezmoi -R apply`. Pulls are `--ff-only`.
- **Never commit inside `~/.config/work`** — a local commit diverges the
  clone and blocks the ff-only pull. Edit in a real checkout of the work
  repo, push, then refresh.

## Layout contract

Work repo root maps to `~/.config/work/`:

| Path | Sourced by | Shell rules |
|---|---|---|
| `homebrew/Brewfile` | `run_after_install-work-packages.sh` (chezmoi after-script, runtime content-hash gated) | n/a |
| `shell/*.sh` | `~/.profile` and `~/.zprofile` | POSIX only |
| `bash/*.sh` | `~/.config/bash/bashrc` | bash 4.2+ (Homebrew bash) |
| `zsh/*.zsh` | `~/.config/zsh/.zshrc`, last | zsh |

Load order is personal first, work second: work files may override aliases,
functions and styles set by the personal config. Last definition wins.
Do not rely on directories existing — every hook is a guarded no-op when
the directory is absent.

## Brewfile rules (Homebrew 7)

1. `tap` entries first. Private taps need an explicit SSH clone target.
2. Every non-official `brew`/`cask` entry **must** carry `trusted: true`
   (Homebrew 7 tap trust). The attribute persists into
   `~/.config/homebrew/trust.json` during `brew bundle install` — no
   separate `brew trust` step.
3. Official (homebrew/core, homebrew/cask) entries stay plain.
4. Language stanzas are allowed; v7 supports git sources for `cargo`/`uv`.
5. One file per machine type is expected — this Brewfile is additive on top
   of the personal Brewfile (`brew bundle install` never removes).

### Skeleton

```ruby
# Work Brewfile — layered on top of the personal Brewfile.
tap "workorg/homebrew-tools", "git@github.com:workorg/homebrew-tools.git"

# Official entries: plain.
brew "gh"

# Third-party entries: trusted: true required.
brew "workorg/homebrew-tools/worktool", trusted: true
cask "workorg/homebrew-tools/workapp", trusted: true

# Language tools from git repos are fine.
# go "github.com/workorg/some-cli"
```

### Hazards

- **Never `brew bundle cleanup` against either Brewfile on a work machine.**
  Cleanup against the personal file resets the global trust store to that
  file's entries only (work taps become untrusted); cleanup against the work
  file uninstalls everything not declared in it (including personal
  packages). Cleanup is a personal-machine, personal-file operation only.
- Secrets never live in this repo or its shell files — use `op plugin` or
  `op read` at runtime.

### Validation before pushing

```sh
brew deps --brewfile homebrew/Brewfile     # review the dependency tree
brew bundle check --file homebrew/Brewfile # verify installed state
brew trust --json v1                       # inspect the trust store
bash -n shell/*.sh bash/*.sh               # shell syntax
zsh -n zsh/*.zsh                           # zsh syntax
```
