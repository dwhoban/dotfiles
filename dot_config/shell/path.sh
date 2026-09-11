# Homebrew (Apple Silicon)
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Local binaries (~/.local/bin for uv, ~/bin), prepended only if not already on PATH
for _dir in "$HOME/.local/bin" "$HOME/bin"; do
    case ":$PATH:" in
        *":$_dir:"*) ;;
        *) PATH="$_dir:$PATH" ;;
    esac
done
unset _dir
