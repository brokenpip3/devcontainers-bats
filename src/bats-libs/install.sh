#!/bin/sh

_log() {
    printf "$(date "+%Y-%m-%d %H:%M:%S") - %s - %s\n" "${1}" "${2}"
}

# To let this script run in alpine (without bash, only busybox sh) we can't use:
# * bash array
# * indirect expansion (https://www.shellcheck.net/wiki/SC3053)

_LIBS="support:0.3.0 assert:2.1.0 detik:1.2.0 file:0.3.0"

loop() {
    for lib in $_LIBS; do
        K=${lib%%:*}
        V=${lib#*:}
        IN=$(printenv "$K")
        if [ "${IN}" = "latest" ]; then
            _log INFO "Bats-$K version is latest, installing default ${V}"
            ./install_libs.sh "$K" "${V}"
            continue
        elif [ "${IN}" = "none" ]; then
            _log INFO "Bats-$K version is none, skipping.."
            continue
        else
            _log INFO "Bats-$K is version ${IN}, installing"
            ./install_libs.sh "$K" "${IN}"
        fi
    done
}

_log INFO "Devcontainer: Installing BATS libs from https://github.com/bats-core"
loop
_log INFO "Done"
