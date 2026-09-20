#!/bin/sh

# FIXME inline install.sh here instead of using curl | sh
# FIXME consider using packages to install chezmoi on deb and rpm-based systems

set -e

cd "${HOME}"

is_command() {
	type "${1}" >/dev/null 2>&1
}

# Install Homebrew first so package setup (brew bundle) can rely on it.
# Apple Silicon installs to /opt/homebrew; brew is then put on PATH for
# the rest of this script and for `chezmoi init --apply`.
if ! is_command brew && [ ! -x /opt/homebrew/bin/brew ]; then
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -n "${LOGNAME}" ]; then
	username="${LOGNAME}"
elif [ -n "${USER}" ]; then
	username="${USER}"
elif [ -n "${USERNAME}" ]; then
	username="${USERNAME}"
elif is_command whoami; then
	username="$(whoami)"
elif is_command logname; then
	username="$(logname)"
else
	printf "unable to determine username" 1>&2
	exit 1
fi

sudo=
if [ "${username}" != "root" ]; then
	sudo="sudo "
fi

chezmoi=chezmoi
if is_command chezmoi; then
	chezmoi --version
elif is_command "${HOME}/.local/bin/chezmoi"; then
	chezmoi="${HOME}/.local/bin/chezmoi"
elif is_command "${HOME}/bin/chezmoi"; then
	chezmoi="${HOME}/bin/chezmoi"
elif is_command curl; then
	sh -c "$(curl -fsSL https://get.chezmoi.io/lb)"
	chezmoi="$HOME/.local/bin/chezmoi"
elif is_command wget; then
	sh -c "$(wget -qO- https://get.chezmoi.io/lb)"
	chezmoi="$HOME/.local/bin/chezmoi"
else
	echo "unable to install chezmoi" 1>&2
	exit 1
fi

${chezmoi} init --apply dwhoban

shell="$(awk -F : "\$1 == \"${username}\" { print \$7 }" /etc/passwd)"
rm -rf $HOME/.local/bin/chezmoi
exec "${shell}"
