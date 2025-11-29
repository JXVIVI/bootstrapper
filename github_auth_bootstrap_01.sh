#!/usr/bin/env bash
set -euo pipefail

ENCRYPTED_KEY_FILE="initial_github.key.gpg"
SSH_DIR="$HOME/.ssh"
SSH_KEY_PATH="$SSH_DIR/id_ed25519"
SSH_KEY_PUB_PATH="$SSH_DIR/id_ed25519.pub"

echo "[github_auth_bootstrap_01] Starting GitHub SSH setup..."

# Ensure required packages are installed (Debian)
if ! command -v gpg >/dev/null 2>&1; then
	echo "[github_auth_bootstrap_01] Installing gnupg..."
	sudo apt-get update
	sudo apt-get install -y gnupg
fi

if ! command -v ssh >/dev/null 2>&1; then
	echo "[github_auth_bootstrap_01] Installing OpenSSH client..."
	sudo apt-get update
	sudo apt-get install -y openssh-client
fi

# Check encrypted key exists
if [ ! -f "$ENCRYPTED_KEY_FILE" ]; then
	echo "[github_auth_bootstrap_01] ERROR: $ENCRYPTED_KEY_FILE not found in $(pwd)"
	echo "Make sure you've cloned the bootstrap repo correctly."
	exit 1
fi

# Prepare ~/.ssh
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# If a key already exists, ask before overwriting
if [ -f "$SSH_KEY_PATH" ]; then
	read -r -p "[github_auth_bootstrap_01] $SSH_KEY_PATH already exists. Overwrite? [y/N] " answer
	case "$answer" in
	[Yy]*) echo "Overwriting existing key..." ;;
	*)
		echo "Aborting."
		exit 1
		;;
	esac
fi

echo "[github_auth_bootstrap_01] Decrypting SSH key to $SSH_KEY_PATH..."
gpg --output "$SSH_KEY_PATH" --decrypt "$ENCRYPTED_KEY_FILE"
chmod 600 "$SSH_KEY_PATH"

# Generate public key from private, if missing
if [ ! -f "$SSH_KEY_PUB_PATH" ]; then
	echo "[github_auth_bootstrap_01] Generating public key $SSH_KEY_PUB_PATH..."
	ssh-keygen -y -f "$SSH_KEY_PATH" >"$SSH_KEY_PUB_PATH"
	chmod 644 "$SSH_KEY_PUB_PATH"
fi

echo "[github_auth_bootstrap_01] SSH key installed."

# Optional: basic git config (only if not set)
if ! git config --global user.name >/dev/null 2>&1; then
	read -r -p "Set git user.name for this machine? [y/N] " set_name
	if [[ "$set_name" =~ ^[Yy]$ ]]; then
		read -r -p "Enter git user.name: " git_name
		git config --global user.name "$git_name"
	fi
fi

if ! git config --global user.email >/dev/null 2>&1; then
	read -r -p "Set git user.email for this machine? [y/N] " set_email
	if [[ "$set_email" =~ ^[Yy]$ ]]; then
		read -r -p "Enter git user.email: " git_email
		git config --global user.email "$git_email"
	fi
fi

echo "[github_auth_bootstrap_01] Testing SSH connection to GitHub..."
ssh -T git@github.com || true

echo "[github_auth_bootstrap_01] Done."
