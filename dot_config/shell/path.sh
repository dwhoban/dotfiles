# PATH additions shared by every shell.
# Sourced from ~/.zprofile (zsh) and ~/.profile (sh/bash).
# Keep POSIX: no zsh- or bash-only syntax.
#
# # Set XDG Folders
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_STATE_HOME=${HOME}/.local/state

# Homebrew (Apple Silicon)
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Local binaries, prepended only if not already on PATH
for _dir in "$HOME/.local/bin" "$HOME/bin"; do
    case ":$PATH:" in
        *":$_dir:"*) ;;
        *) [ -d "$_dir" ] && PATH="$_dir:$PATH" ;;
    esac
done
unset _dir
