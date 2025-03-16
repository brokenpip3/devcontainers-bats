#!/bin/sh

_log() {
    printf "$(date "+%Y-%m-%d %H:%M:%S") - %s - %s\n" "${1}" "${2}"
}

# To let this script run in alpine (without bash, only busybox sh) we can't use:
# * bash array
# * indirect expansion (https://www.shellcheck.net/wiki/SC3053)

_LIBS="SUPPORT:0.3.0 ASSERT:2.1.0 DETIK:1.3.3 FILE:0.4.0"

loop() {
    for lib in $_LIBS; do
        K=${lib%%:*}
        V=${lib#*:}
        IN=$(printenv "$K")
	lowerK=$(echo "$K" | tr '[:upper:]' '[:lower:]')
        if [ "${IN}" = "latest" ]; then
            _log INFO "Bats-$lowerK version is latest, installing default ${V}"
            ./install_libs.sh "$lowerK" "${V}"
        elif [ "${IN}" = "none" ]; then
            _log INFO "Bats-$lowerK version is none, skipping.."
        else
            _log INFO "Bats-$lowerK is version ${IN}, installing"
            ./install_libs.sh "$lowerK" "${IN}"
        fi
    done
}

setup() {
# Add bash since it's a prerequisite to use the bats libs
# wget is always present in alpine
if [ -f /etc/alpine-release ]; then
	_log INFO "Installing bash"
	apk update && apk add bash
else
	DEBIAN_FRONTEND=noninteractive
	apt-get update -y
	if ! command -v wget > /dev/null 2>&1; then
		_log WARN "wget is not present, installing"
		apt-get -y install --no-install-recommends wget ca-certificates
	fi
	apt install -y bash
fi
}

_log INFO "Devcontainer: Installing BATS libs from https://github.com/bats-core"
setup
loop
_log INFO "Done"
