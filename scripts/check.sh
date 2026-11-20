#!/bin/sh
# Runs the checks a change must pass. See AGENTS.md.
#
#   ./scripts/check.sh         The fast check, for the edit loop: format, lint, the rules package tests, the app
#                              build and the app's unit tests.
#   ./scripts/check.sh --full  The fast check, then the UI tests, which drive whole flows in the simulator. A pull
#                              request is ready, and may be merged, only when this passes.
#
# The app is built once (build-for-testing) and every test run starts from that build (test-without-building).
# The app's tests take a lock shared by every checkout and the CI runner on this Mac, so only one run uses the
# simulator at a time: a test run installs the app, and two runs would replace each other's app (#204). Each step prints how long it took, and a summary closes the run.
set -eu
cd "$(dirname "$0")/.."

case "${1:-}" in
"") FULL=no ;;
--full) FULL=yes ;;
*)
    echo "usage: scripts/check.sh [--full]" >&2
    exit 64
    ;;
esac

DESTINATION="${TOMI_DESTINATION:-platform=iOS Simulator,name=iPhone 17}"
# One fixed path for the whole Mac, so checkouts in any folder and the CI runner wait for each other.
SIMULATOR_LOCK=/tmp/tomi-check-simulator.lock
CHECK_STARTED=$(date +%s)
TIMES=""

# Runs one step and prints how long it took. A failing step stops the check, because of set -e.
step() {
    name=$1
    shift
    echo "== $name"
    started=$(date +%s)
    "$@"
    seconds=$(($(date +%s) - started))
    echo "-- $name: $seconds s"
    TIMES="$TIMES$(printf '%6d s  %s' "$seconds" "$name")
"
}

# xcodebuild never gets the simulator lock's descriptor (9>&-, see below). The close sits on the command itself:
# on a function call the shell keeps a copy of the descriptor open, and the children inherit it.
app_xcodebuild() {
    xcodebuild -project Tomi.xcodeproj -scheme Tomi -destination "$DESTINATION" \
        -derivedDataPath build/DerivedData -quiet "$@" 9>&-
}

build_for_testing() {
    app_xcodebuild build-for-testing
}

# Runs one test bundle from the build above.
# Without "never", every failing UI test makes the simulator collect a sysdiagnose, which can sit for ten
# minutes before the failure is reported. The test output already names what failed.
# Run one simulator at a time: concurrent clones coincided with high load and UI test runner failures (#170).
test_bundle() {
    app_xcodebuild -parallel-testing-enabled NO -collect-test-diagnostics never \
        -only-testing:"$1" test-without-building
}

# Takes the Mac's simulator lock before the first test step. The lock is a BSD file lock on descriptor 9, held by
# this shell until it exits: the kernel drops it then, however it ends, so a crashed or killed run never leaves
# it behind. xcodebuild gets descriptor 9 closed, so a process left running after a killed run, such as a
# simulator service, cannot keep holding the lock.
take_simulator_lock() {
    exec 9>>"$SIMULATOR_LOCK"
    wait_for_simulator_lock
    echo "pid $$ in $(pwd), since $(date '+%Y-%m-%d %H:%M:%S')" >"$SIMULATOR_LOCK"
}

wait_for_simulator_lock() {
    if lockf -s -t 0 9; then
        return
    fi
    holder=$(cat "$SIMULATOR_LOCK")
    echo "Another check is testing in the simulator on this Mac (${holder:-holder unknown}). Waiting for it to finish."
    waiting_since=$(date +%s)
    lockf -s 9
    echo "Took the simulator lock after $(($(date +%s) - waiting_since)) s."
}

print_times() {
    echo "== Times"
    printf '%s' "$TIMES"
    printf '%6d s  %s\n' "$(($(date +%s) - CHECK_STARTED))" "Total"
}

step "Format and lint" xcrun swift-format lint --strict --recursive Tomi TomiTests TomiUITests Packages/TomiCore
step "Size limits, hard-coded text and other lint rules" swiftlint lint --strict --quiet
step "Rules package tests" swift test --package-path Packages/TomiCore
step "App build for testing" build_for_testing
step "Waiting for the simulator, one test run at a time on this Mac" take_simulator_lock
step "App unit tests" test_bundle TomiTests
if [ "$FULL" = no ]; then
    print_times
    echo "Fast checks passed. Run ./scripts/check.sh --full before the pull request is called ready."
    exit 0
fi
step "App UI tests" test_bundle TomiUITests
print_times
echo "All checks passed."
