# Environment variables shared by every shell.
# Sourced from ~/.zprofile (zsh) and ~/.profile (sh/bash).

# Oh My Pi / OpenCode
export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=true

# 1Password SSH agent
if [ -e "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]; then
    export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi
