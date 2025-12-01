#!/usr/bin/env bash
set -euo pipefail

source "./colors.sh"

BOOTSTRAP_OS="$1"
BOOTSTRAP_SHELL="$2"

export BOOTSTRAP_OS
export BOOTSTRAP_SHELL

info "Installing core tools on Arch (git, gnupg, openssh)..."

sudo pacman -Sy --noconfirm \
  git \
  gnupg \
  openssh \
  base-devel

ok "Base tools installed."

info "Installing yay (AUR helper)..."

# Remove old yay clone if it exists
rm -rf /tmp/yay-bootstrap
mkdir -p /tmp/yay-bootstrap
cd /tmp/yay-bootstrap

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

cd /
rm -rf /tmp/yay-bootstrap

ok "yay installed."

next_script="./github_auth_bootstrap_01.sh"

info "Running $next_script..."
"$next_script" "$BOOTSTRAP_OS" "$BOOTSTRAP_SHELL"
