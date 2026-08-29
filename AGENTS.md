# AGENTS.md

Chezmoi source state for my dotfiles. This directory IS the chezmoi source
(`~/.local/share/chezmoi`, symlinked from `~/Workspace/projects/dotfiles`);
everything managed here deploys into `$HOME` on `chezmoi apply`.
Remote: `github.com/dwhoban/dotfiles` (SSH), branch `main`.
Toolchain: Homebrew 6.x at `/opt/homebrew` (Apple Silicon macOS), chezmoi 2.72+ via Homebrew.

## Fresh machine bootstrap

```
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply dwhoban/dotfiles
```

First-apply order: `run_once_before_darwin-install-homebrew.sh.tmpl` installs
Homebrew if missing → managed targets written (incl. `~/.zprofile` with brew
shellenv) → `run_onchange_darwin-install-packages.sh.tmpl` runs `brew bundle`
over `.chezmoidata/packages.yaml`.

## Commands

- Preview: `chezmoi diff` (dry-run: `chezmoi apply --dry-run --verbose`)
- Deploy: `chezmoi apply`
- Add an existing dotfile: `chezmoi add ~/.zshrc` — never hand-create source files
- Edit and re-apply: `chezmoi edit --apply ~/.zshrc`
- List managed targets: `chezmoi managed`
- Pull + apply on another machine: `chezmoi update`

## Gotchas

- Name transforms: target `~/.zshrc` is stored as `dot_zshrc`; attribute
  prefixes: `private_`, `executable_`, `symlink_`, `run_`, `create_`,
  `modify_`, `once_`, `before_`, `after_`, `onchange_`. A literal `.zshrc` in
  the source dir is IGNORED — chezmoi skips dot-prefixed entries unless they
  are `.chezmoi*` special files.
- Repo tooling files (README.md, AGENTS.md, opencode.json) are deploy targets
  too unless listed in `.chezmoiignore`. (README.md once appeared in
  `chezmoi managed` and would have been applied as `~/README.md`.)
- Scripts must never write to files chezmoi manages (e.g. `~/.zprofile`) —
  edit the managed source file (`dot_zprofile.tmpl`) instead.
- Templates are Go templates with `missingkey=error`: an undefined variable
  fails the apply. Template data lives in `.chezmoidata/` and
  `.chezmoi.toml.tmpl` (renders to `~/.config/chezmoi/chezmoi.toml`).
- Templates that render empty are skipped by chezmoi (used for OS guards);
  `run_once_`/`run_onchange_` state lives in `~/.local/state/chezmoi` — reset
  with `chezmoi state delete-bucket --bucket=scriptState`.

## Declarative packages (Homebrew)

- Edit `.chezmoidata/packages.yaml` (`taps` / `brews` / `casks`), then
  `chezmoi apply`. The `run_onchange_` script re-runs only when the rendered
  package list changes.
- `brew bundle` ensures presence only — it never upgrades; upgrade manually.
- Third-party packages need fully-qualified names (`anomalyco/tap/opencode`,
  `daptify14/tap/chezit`) and their taps declared in `taps`.
