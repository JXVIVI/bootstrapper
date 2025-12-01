#!/usr/bin/env bash
set -euo pipefail

source "./colors.sh"

BOOTSTRAP_OS="$1"
BOOTSTRAP_SHELL="$2"

export BOOTSTRAP_OS
export BOOTSTRAP_SHELL

info "Setting default shell to: $BOOTSTRAP_SHELL"

case "$BOOTSTRAP_SHELL" in
  bash)
    SHELL_PATH="$(command -v bash)"
    ;;
  zsh)
    SHELL_PATH="$(command -v zsh)"
    ;;
  fish)
    SHELL_PATH="$(command -v fish)"
    ;;
  nushell|nu|nushell.sh)
    # assuming package installs a `nu` binary
    SHELL_PATH="$(command -v nu)"
    ;;
  *)
    error "Unknown shell: $BOOTSTRAP_SHELL"
    ;;
esac

info "Changing login shell to: $SHELL_PATH"
chsh -s "$SHELL_PATH"

ok "Default shell updated. You may need to log out and back in for it to apply."
