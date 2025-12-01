#!/usr/bin/env bash
set -euo pipefail

source "./colors.sh"

BOOTSTRAP_OS="${1:-debian}"
BOOTSTRAP_SHELL="${2:-bash}"

export BOOTSTRAP_OS
export BOOTSTRAP_SHELL

info "Installing core tools on Debian (git, gnupg, openssh-client)..."

sudo apt update
sudo apt install -y \
  git \
  gnupg \
  openssh-client

ok "Core tools installed on Debian."

next_script="./github_auth_bootstrap_01.sh"

info "Running $next_script..."
"$next_script" "$BOOTSTRAP_OS" "$BOOTSTRAP_SHELL"
