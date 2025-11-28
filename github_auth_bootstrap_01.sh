#!/usr/bin/env bash
set -euo pipefail

# github_auth_bootstrap_01.sh
#
# Purpose:
#   - Decrypt an SSH key encrypted with GPG (symmetric) and install it as ~/.ssh/id_ed25519
#   - Optionally configure global git user.name / user.email
#
# Expects:
#   - initial_github.key.gpg in the same directory as this script
#   - Debian-based system, sudo available

# Colors (Tokyodark-ish)
RESET='\033[0m'
FG_PURPLE='\033[38;2;169;177;214m'
FG_GREEN='\033[38;2;152;195;121m'
FG_YELLOW='\033[38;2;224;175;104m'
FG_RED='\033[38;2;224;108;117m'
FG_GREY='\033[38;2;92;99;112m'

info()  { printf "${FG_PURPLE}[*]${RESET} %s\n" "$1"; }
ok()    { printf "${FG_GREEN}[✓]${RESET} %s\n" "$1"; }
warn()  { printf "${FG_YELLOW}[!]${RESET} %s\n" "$1"; }
error() { printf "${FG_RED}[✗]${RESET} %s\n" "$1"; }
note()  { printf "${FG_GREY}[-] %s${RESET}\n" "$1"; }

BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENCRYPTED_KEY="$BOOTSTRAP_DIR/initial_github.key.gpg"
SSH_DIR="$HOME/.ssh"
SSH_KEY_PATH="$SSH_DIR/id_ed25519"

info "Setting up GitHub SSH key from encrypted file..."

if ! command -v gpg >/dev/null 2>&1; then
    info "gpg not found, installing (requires sudo)..."
    sudo apt update
    sudo apt install -y gnupg
    ok "gpg installed."
else
    note "gpg already installed."
fi

if [ ! -f "$ENCRYPTED_KEY" ]; then
    error "Encrypted key not found at: $ENCRYPTED_KEY"
    echo "    Expected file: initial_github.key.gpg next to this script."
    exit 1
fi

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [ -f "$SSH_KEY_PATH" ]; then
    warn "$SSH_KEY_PATH already exists."
    read -rp "$(printf "${FG_YELLOW}    Overwrite existing SSH key? [y/N] ${RESET}")" ans
    case "$ans" in
        y|Y) info "Overwriting existing SSH key...";;
        *) note "Aborting to avoid overwriting existing key."; exit 1;;
    esac
fi

info "Decrypting SSH key to $SSH_KEY_PATH (you'll be prompted for passphrase)..."
gpg --decrypt "$ENCRYPTED_KEY" > "$SSH_KEY_PATH"
chmod 600 "$SSH_KEY_PATH"
ok "SSH private key written to $SSH_KEY_PATH."

if [ ! -f "$SSH_KEY_PATH.pub" ]; then
    if ssh-keygen -y -f "$SSH_KEY_PATH" >/dev/null 2>&1; then
        info "Generating public key from private key..."
        ssh-keygen -y -f "$SSH_KEY_PATH" > "$SSH_KEY_PATH.pub"
        ok "Public key written to $SSH_KEY_PATH.pub"
    else
        warn "Could not automatically generate public key with ssh-keygen."
    fi
else
    note "Public key already exists at $SSH_KEY_PATH.pub"
fi

warn "Make sure this public key is added to your GitHub account (if not already)."

read -rp "$(printf "${FG_PURPLE}[?] Configure global git user.name and user.email now? [y/N] ${RESET}")" cfg_ans
if [[ "$cfg_ans" == "y" || "$cfg_ans" == "Y" ]]; then
    read -rp "  - git user.name: " git_user
    read -rp "  - git user.email: " git_email

    git config --global user.name "$git_user"
    git config --global user.email "$git_email"
    ok "Global git user.name and user.email configured."
else
    note "Skipping git user config."
fi

ok "GitHub SSH setup complete. You should now be able to use git@github.com:... URLs from this machine."
