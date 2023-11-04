#!/usr/bin/env bash
source dev-container-features-test-lib

check "Bats support directory is present" test -d "/usr/lib/bats/bats-support"
check "Bats assert directory is present" test -d "/usr/lib/bats/bats-assert"
check "Bats detik directory is present" test -d "/usr/lib/bats/bats-detik"
check "Bats file directory is present" test -d "/usr/lib/bats/bats-file"

reportResults
