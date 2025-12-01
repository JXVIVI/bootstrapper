#!/usr/bin/env bash

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
