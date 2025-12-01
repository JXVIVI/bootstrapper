#!/usr/bin/env bash
set -euo pipefail

source "./colors.sh"

DOTFILES_REPO_SSH_URL="git@github.com:jackfr-thg/dotfiles.git"
DOTFILES_DIRECTORY="$HOME/dotfiles"

info "Removing existing dotfiles directory at $DOTFILES_DIRECTORY (if any)..."
rm -rf "$DOTFILES_DIRECTORY"

info "Cloning dotfiles from $DOTFILES_REPO_SSH_URL..."
git clone "$DOTFILES_REPO_SSH_URL" "$DOTFILES_DIRECTORY"
ok "Dotfiles cloned."

next_script="./install_tools_bootstrap_03.sh"

info "Running $next_script..."
"$next_script" "$BOOTSTRAP_OS" "$BOOTSTRAP_SHELL"
