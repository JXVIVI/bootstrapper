#!/usr/bin/env bash
set -euo pipefail

source "./colors.sh"

BOOTSTRAP_OS="$1"
BOOTSTRAP_SHELL="$2"

export BOOTSTRAP_OS
export BOOTSTRAP_SHELL

info "Installing core tools on macOS (git, gnupg, openssh)..."

# Install Homebrew if it's not present
if ! command -v brew >/dev/null 2>&1; then
    info "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Apple Silicon users need this line; Intel users ignore it
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.bash_profile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ok "Homebrew installed."
else
    info "Homebrew already present."
fi

brew update
brew install \
  git \
  gnupg \
  openssh

ok "Core tools installed on macOS."

next_script="./github_auth_bootstrap_01.sh"

info "Running $next_script..."
"$next_script" "$BOOTSTRAP_OS" "$BOOTSTRAP_SHELL"
