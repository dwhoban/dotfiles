# dotfiles

Dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Fresh machine setup

```
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply dwhoban/dotfiles
```

On first apply, this installs Homebrew (if missing), deploys the dotfiles, then
installs every package declared in `.chezmoidata/packages.yaml` via `brew bundle`.
