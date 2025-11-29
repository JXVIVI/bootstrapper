#!/usr/bin/env bash
set -euo pipefail

# dotfiles_clone_bootstrap_03.sh
#
# Clone the private dotfiles repo into ~/dotfiles and run its symlink setup script.
#
# Expects:
#   - GitHub SSH auth already working (via github_auth_bootstrap_01.sh)
#   - dotfiles repo accessible at DOTFILES_REPO_SSH_URL
#   - symlink script inside dotfiles at: ~/dotfiles/setup/dotfiles_symlinks_bootstrap_04.sh

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

# Set your private dotfiles repo SSH URL here:
DOTFILES_REPO_SSH_URL="git@github.com:JXVIVI/dotfiles.git"

DOTFILES_DIR="$HOME/dotfiles"
SYMLINK_SCRIPT_REL="setup/dotfiles_symlinks_bootstrap_04.sh"
SYMLINK_SCRIPT="$DOTFILES_DIR/$SYMLINK_SCRIPT_REL"

info "Cloning dotfiles repo into $DOTFILES_DIR..."

if [ -d "$DOTFILES_DIR/.git" ]; then
	warn "$DOTFILES_DIR already looks like a git repo."
	read -rp "$(printf "${FG_YELLOW}    Re-clone dotfiles repo (this will remove existing directory)? [y/N] ${RESET}")" ans
	case "$ans" in
	y | Y)
		info "Removing existing $DOTFILES_DIR..."
		rm -rf "$DOTFILES_DIR"
		;;
	*)
		note "Keeping existing dotfiles directory."
		;;
	esac
fi

if [ ! -d "$DOTFILES_DIR" ]; then
	if [ "$DOTFILES_REPO_SSH_URL" = "git@github.com:YOUR_USERNAME/YOUR_DOTFILES_REPO.git" ]; then
		warn "DOTFILES_REPO_SSH_URL is still the placeholder."
		error "Edit dotfiles_clone_bootstrap_03.sh and set your actual dotfiles repo SSH URL."
		exit 1
	fi

	info "Cloning from $DOTFILES_REPO_SSH_URL..."
	git clone "$DOTFILES_REPO_SSH_URL" "$DOTFILES_DIR"
	ok "Dotfiles cloned to $DOTFILES_DIR."
else
	note "$DOTFILES_DIR already exists; skipping clone."
fi

if [ ! -f "$SYMLINK_SCRIPT" ]; then
	error "Symlink setup script not found at: $SYMLINK_SCRIPT"
	echo "    Expected path: ~/dotfiles/$SYMLINK_SCRIPT_REL"
	exit 1
fi

info "Ensuring symlink script is executable..."
chmod +x "$SYMLINK_SCRIPT"

info "Running dotfiles symlink bootstrap script..."
"$SYMLINK_SCRIPT"

ok "Dotfiles symlink setup complete."
