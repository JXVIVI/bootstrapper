#!/usr/bin/env bash
set -euo pipefail

# core_tools_bootstrap_00.debian.sh
#
# PURPOSE:
#   Install the absolute minimum required tools BEFORE running any bootstrap steps:
#     - git                → needed to clone the bootstrap repo
#     - gnupg              → needed to decrypt the encrypted GitHub SSH key (01 script)
#     - openssh-client     → provides ssh + ssh-keygen (01 script)
#
#   Also makes all other bootstrap scripts executable:
#     - github_auth_bootstrap_01.sh
#     - install_tools_bootstrap_02.debian.sh
#     - dotfiles_clone_bootstrap_03.sh
#
# AFTER THIS:
#   You simply run:
#       ./github_auth_bootstrap_01.sh
#       ./install_tools_bootstrap_02.debian.sh
#       ./dotfiles_clone_bootstrap_03.sh
#

# Colors
RESET='\033[0m'
FG_PURPLE='\033[38;2;169;177;214m'
FG_GREEN='\033[38;2;152;195;121m'
FG_YELLOW='\033[38;2;224;175;104m'
FG_RED='\033[38;2;224;108;117m'
FG_GREY='\033[38;2;92;99;112m'

info()  { printf "${FG_PURPLE}[*]${RESET} %s\n" "$1"; }
ok()    { printf "${FG_GREEN}[✓]${RESET} %s\n" "$1"; }
warn()  { printf "${FG_YELLOW}[!]${RESET} %s\n" "$1"; }
error() { printf "${FG_RED}[✗]${RESET} %s\n" "$1"; exit 1; }
note()  { printf "${FG_GREY}[-] %s${RESET}\n" "$1"; }

info "Installing core tools: git, gnupg, openssh-client..."

sudo apt update

sudo apt install -y \
    git \
    gnupg \
    openssh-client

ok "Core tools installed."

info "Checking for other bootstrap scripts..."

FILES=(
    "github_auth_bootstrap_01.sh"
    "install_tools_bootstrap_02.debian.sh"
    "dotfiles_clone_bootstrap_03.sh"
)

for f in "${FILES[@]}"; do
    if [ -f "$f" ]; then
        chmod +x "$f"
        ok "Made executable: $f"
    else
        warn "Missing expected file: $f"
    fi
done

ok "Bootstrap stage 00 complete."
echo
echo "Next steps:"
echo "    ./github_auth_bootstrap_01.sh"
echo "    ./install_tools_bootstrap_02.debian.sh"
echo "    ./dotfiles_clone_bootstrap_03.sh"
echo
