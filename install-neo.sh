#!/bin/bash
#
# Neovim releases: https://github.com/neovim/neovim/releases
# fzf releases: https://github.com/junegunn/fzf/releases
# ripgrep releases: https://github.com/burntsushi/ripgrep/releases
#
# This script is hard-coded to Linux x86_64 set ups for now.

set -e

# Script name.
_SCRIPT_NAME=$(basename "$0")

# Directory for binaries.
_BIN_DIR=$HOME/.local/bin

# Source URLs.
_NEOVIM_URL="https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.appimage"
_FZF_URL="https://github.com/junegunn/fzf/releases/download/v0.62.0/fzf-0.62.0-linux_amd64.tar.gz"
_RIPGREP_URL="https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz"

usage() {
    echo "Usage: $_SCRIPT_NAME [OPTIONS]"
    echo ""
    echo "Description:"
    echo "  Install neovim."
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message and exit."
    echo "  -d, --dry-run   Print commands without running them."
    echo ""
    echo "Examples:"
    echo "  $_SCRIPT_NAME"
}

_dry_run=0
while [[ $# -gt 0 ]]; do
    case "$1" in
    -d|--dry-run)
        _dry_run=1
        shift
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        echo "Error: Unable to parse args." >&2
        usage
        exit 1
        shift
        ;;
    esac
done


run_cmd() {
    local cmd="$*"
    echo "Command [dry=${_dry_run}]: ${cmd}"
    if [[ ${_dry_run} == 0 ]]; then
        "$@"
    fi
}

install_neovim() {
    have_nvim=1
    nvim --help > /dev/null 2>&1 || have_nvim=0
    if [[ ${have_nvim} == 0 ]]; then
        run_cmd wget ${_NEOVIM_URL} -O ${_BIN_DIR}/nvim
        run_cmd chmod +x ${_BIN_DIR}/nvim
    fi
}

install_fzf() {
    have_fzf=1
    fzf --help > /dev/null 2>&1 || have_fzf=0
    if [[ ${have_fzf} == 0 ]]; then
        local tmp_dir=$(mktemp -d)
        run_cmd wget ${_FZF_URL} -O ${tmp_dir}/fzf_linux_amd64.tar.gz
        run_cmd tar -xzvf ${tmp_dir}/fzf_linux_amd64.tar.gz -C ${tmp_dir}
        run_cmd mv ${tmp_dir}/fzf ${_BIN_DIR}/
        rm -rf ${tmp_dir}
    fi
}

install_ripgrep() {
    have_rg=1
    rg --help > /dev/null 2>&1 || have_rg=0
    if [[ ${have_rg} == 0 ]]; then
        local tmp_dir=$(mktemp -d)
        run_cmd wget ${_RIPGREP_URL} -O ${tmp_dir}/rg.tar.gz
        run_cmd tar -xzvf ${tmp_dir}/rg.tar.gz -C ${tmp_dir}
        run_cmd mv $(find ${tmp_dir} -name rg) ${_BIN_DIR}/
        rm -rf ${tmp_dir}
    fi
}

install_neovim
install_fzf
install_ripgrep
