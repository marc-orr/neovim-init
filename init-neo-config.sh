#!/bin/bash

set -e

# Script name.
_SCRIPT_NAME=$(basename "$0")

# Sub-commands.
_NUKE_CMD="nuke"
_POPULATE_CMD="populate"

# Neovim configs.
_NVIM_CONFIG_HOME="$HOME/.config/nvim/"
_NVIM_LOCAL_SHARE="$HOME/.local/share/nvim/"
_NVIM_LOCAL_STATE="$HOME/.local/state/nvim/"
_NVIM_LOCAL_CACHE="$HOME/.cache/nvim/"

usage() {
    echo "Usage: $_SCRIPT_NAME [OPTIONS]"
    echo ""
    echo "Description:"
    echo "  Initializes neovim configs."
    echo ""
    echo "Commands:"
    echo "  ${_POPULATE_CMD}      Populate the initial neovim configs."
    echo "  ${_NUKE_CMD}          Delete pre-existing neovim configs."
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message and exit."
    echo "  -d, --dry-run   Print commands without running them."
    echo ""
    echo "Examples:"
    echo "  $_SCRIPT_NAME populate"
    echo "  $_SCRIPT_NAME nuke"
}

_dry_run=0
_cmd=
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
        if [[ -z "${_cmd}" ]]; then
            _cmd="${1}"
        else
            echo "Error: Too many positional arguments." >&2
            usage
            exit 1
	fi
        shift
	;;
    esac
done


if [[ -z "${_cmd}" ]]; then
    echo "Error: Must specify a sub-command." >&2
    usage
    exit 1
fi

run_cmd() {
    local cmd="$*"
    echo "Command [dry=${_dry_run}]: ${cmd}"
    if [[ ${_dry_run} == 0 ]]; then
        "$@"
    fi
}

check_for_nvim_config() {
    if [[ -d "${_NVIM_CONFIG_HOME}" ]]; then
        echo "Error: Neovim config already exists @ ${_NVIM_CONFIG_HOME}" >&2
	echo "Error: Cannot install new Neovim config" >&2
	echo "Error: To remove pre-existing config, run: $_SCRIPT_NAME nuke"
	exit 1
    fi
}

copy_nvim_config() {
    run_cmd mkdir -p ${_NVIM_CONFIG_HOME}
    run_cmd cp -r nvim-config/* ${_NVIM_CONFIG_HOME}
}

populate_configs() {
    check_for_nvim_config
    copy_nvim_config
}

# Remove pre-existing neovim configs.
nuke_configs() {
    run_cmd rm -rf ${_NVIM_CONFIG_HOME}
    run_cmd rm -rf ${_NVIM_LOCAL_SHARE}
    run_cmd rm -rf ${_NVIM_LOCAL_STATE}
    run_cmd rm -rf ${_NVIM_LOCAL_CACHE}
}

if [[ ${_cmd} == ${_POPULATE_CMD} ]]; then
    populate_configs
elif [[ ${_cmd} == ${_NUKE_CMD} ]]; then
    nuke_configs
else
    echo "Error: Invalid command: ${_cmd}"
    usage
    exit 1
fi
