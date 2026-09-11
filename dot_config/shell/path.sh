# PATH additions shared by every shell.
# Sourced from ~/.zprofile (zsh) and ~/.profile (sh/bash).
# Keep POSIX: no zsh- or bash-only syntax.

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
