#!/usr/bin/env bash
set -euo pipefail

source "./colors.sh"

info "Making all .sh files executable..."
for script_path in ./*.sh; do
    [ -f "$script_path" ] && chmod +x "$script_path" && info "Executable: $script_path"
done

printf "\n"

info "Select OS:"
printf "${FG_PURPLE}  1) arch${RESET}\n"
printf "${FG_PURPLE}  2) debian${RESET}\n"
printf "${FG_PURPLE}  3) mac${RESET}\n"
printf "${FG_YELLOW}Enter choice: ${RESET}"
read -r os_choice

case "$os_choice" in
  1) BOOTSTRAP_OS="arch" ;;
  2) BOOTSTRAP_OS="debian" ;;
  3) BOOTSTRAP_OS="mac" ;;
  *) error "Invalid option." ;;
esac

printf "\n"

info "Select shell:"
printf "${FG_PURPLE}  1) bash${RESET}\n"
printf "${FG_PURPLE}  2) zsh${RESET}\n"
printf "${FG_PURPLE}  3) fish${RESET}\n"
printf "${FG_PURPLE}  4) nushell${RESET}\n"
printf "${FG_YELLOW}Enter choice: ${RESET}"
read -r shell_choice

case "$shell_choice" in
  1) BOOTSTRAP_SHELL="bash" ;;
  2) BOOTSTRAP_SHELL="zsh"  ;;
  3) BOOTSTRAP_SHELL="fish" ;;
  4) BOOTSTRAP_SHELL="nushell" ;;
  *) error "Invalid option." ;;
esac

export BOOTSTRAP_OS
export BOOTSTRAP_SHELL

printf "\n"
ok "OS: $BOOTSTRAP_OS"
ok "Shell: $BOOTSTRAP_SHELL"
printf "\n"

core_script="core_tools_bootstrap_00.${BOOTSTRAP_OS}.sh"

info "Running $core_script..."
./"$core_script" "$BOOTSTRAP_OS" "$BOOTSTRAP_SHELL"

ok "Bootstrap init complete."
