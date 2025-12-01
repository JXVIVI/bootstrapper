#!/usr/bin/env bash
set -euo pipefail

source "./colors.sh"

BOOTSTRAP_OS="$1"
BOOTSTRAP_SHELL="$2"

export BOOTSTRAP_OS
export BOOTSTRAP_SHELL

ENCRYPTED_KEY_FILE="initial_github.key.gpg"
SSH_DIR="$HOME/.ssh"
SSH_KEY_PATH="$SSH_DIR/id_ed25519"
SSH_KEY_PUB_PATH="$SSH_DIR/id_ed25519.pub"

info "GitHub SSH setup starting..."

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

info "Decrypting SSH key to $SSH_KEY_PATH..."
gpg --output "$SSH_KEY_PATH" --decrypt "$ENCRYPTED_KEY_FILE"
chmod 600 "$SSH_KEY_PATH"

info "Generating public key..."
ssh-keygen -y -f "$SSH_KEY_PATH" >"$SSH_KEY_PUB_PATH"
chmod 644 "$SSH_KEY_PUB_PATH"

ok "SSH key installed."

info "Testing SSH connection to GitHub..."
ssh -T git@github.com || true

ok "GitHub SSH setup complete."

next_script="./dotfiles_clone_bootstrap_02.sh"

info "Running $next_script..."
"$next_script" "$BOOTSTRAP_OS" "$BOOTSTRAP_SHELL"
