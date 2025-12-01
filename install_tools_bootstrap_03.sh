#!/usr/bin/env bash
set -euo pipefail

source "./colors.sh"

BOOTSTRAP_OS="$1"
BOOTSTRAP_SHELL="$2"

export BOOTSTRAP_OS
export BOOTSTRAP_SHELL

DOTFILES_DIR="$HOME/dotfiles"
PACKAGES_DIR="$DOTFILES_DIR/packages"

COMMON_LIST="$PACKAGES_DIR/common.txt"
DEBIAN_LIST="$PACKAGES_DIR/debian.txt"
ARCH_LIST="$PACKAGES_DIR/arch.txt"
MAC_LIST="$PACKAGES_DIR/mac.txt"

install_debian_tools() {
	info "Installing CLI tools on Debian..."

	sudo apt update
	xargs -a "$COMMON_LIST" -r sudo apt install -y
	xargs -a "$DEBIAN_LIST" -r sudo apt install -y

	info "Normalising fd / bat names..."
	sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd || true
	sudo ln -sf "$(command -v batcat || command -v bat)" /usr/local/bin/bat || true

	ok "Tool installation completed on Debian."
}

install_arch_tools() {
	info "Installing CLI tools on Arch..."

	sudo pacman -Sy --noconfirm

	xargs -a "$COMMON_LIST" -r yay -S --noconfirm
	xargs -a "$ARCH_LIST" -r yay -S --noconfirm

	ok "Tool installation completed on Arch."
}

install_mac_tools() {
	info "Installing CLI tools on macOS..."

	brew update
	xargs -a "$COMMON_LIST" -r brew install
	xargs -a "$MAC_LIST" -r brew install

	ok "Tool installation completed on macOS."
}

case "$BOOTSTRAP_OS" in
debian) install_debian_tools ;;
arch) install_arch_tools ;;
mac) install_mac_tools ;;
*) error "Unknown OS: $BOOTSTRAP_OS" ;;
esac

next_script="./setup_symlinks_bootstrap_04.sh"

info "Running $next_script..."
"$next_script" "$BOOTSTRAP_OS" "$BOOTSTRAP_SHELL"
