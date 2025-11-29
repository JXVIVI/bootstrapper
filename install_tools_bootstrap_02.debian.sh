#!/usr/bin/env bash
set -euo pipefail

# install_tools_bootstrap_02.debian.sh
#
# Install core CLI tools for the homelab server on Debian.
# Intentionally Debian-specific (apt, fd-find/batcat quirks).

# Colors (Tokyodark-ish)
RESET='\033[0m'
FG_PURPLE='\033[38;2;169;177;214m'
FG_GREEN='\033[38;2;152;195;121m'
FG_YELLOW='\033[38;2;224;175;104m'
FG_RED='\033[38;2;224;108;117m'
FG_GREY='\033[38;2;92;99;112m'

info() { printf "${FG_PURPLE}[*]${RESET} %s\n" "$1"; }
ok() { printf "${FG_GREEN}[✓]${RESET} %s\n" "$1"; }
warn() { printf "${FG_YELLOW}[!]${RESET} %s\n" "$1"; }
error() { printf "${FG_RED}[✗]${RESET} %s\n" "$1"; }
note() { printf "${FG_GREY}[-] %s${RESET}\n" "$1"; }

info "Installing core CLI tools via apt (Debian)..."

sudo apt update

sudo apt install -y \
	fish \
	git \
	curl \
	wget \
	htop \
	ripgrep \
	neovim \
	build-essential \
	pkg-config \
	tmux \
	fzf \
	fd-find \
	bat \
	zoxide \
	starship \
	xclip \
	unzip \
	zip

ok "Base packages installed."

# fd-find binary is typically `fdfind`; create `fd` symlink if not present.
if command -v fdfind >/dev/null 2>&1; then
	if ! command -v fd >/dev/null 2>&1; then
		info "Creating /usr/local/bin/fd -> fdfind symlink..."
		sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
		ok "fd command now available."
	else
		note "fd command already available."
	fi
else
	warn "fd-find not found; fd command will not be available."
fi

# bat binary is typically `batcat` on Debian; create `bat` symlink if not present.
if command -v batcat >/dev/null 2>&1; then
	if ! command -v bat >/dev/null 2>&1; then
		info "Creating /usr/local/bin/bat -> batcat symlink..."
		sudo ln -sf "$(command -v batcat)" /usr/local/bin/bat
		ok "bat command now available."
	else
		note "bat command already available."
	fi
else
	warn "bat (batcat) not found; bat command will not be available."
fi

ok "Tool installation completed (Debian). fish, tmux, nvim, fzf, zoxide, starship etc. should now be ready."
