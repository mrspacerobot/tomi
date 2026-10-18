#!/bin/sh
# Builds the app, installs it on a simulator and launches it against the chosen backend. See AGENTS.md.
#
#   scripts/run.sh [cloud|local|fake] [extra launch arguments...]
#
#   cloud  the deployed server and the real sign-in (the default)
#   local  the server on this Mac (localhost:8080) and the real sign-in
#   fake   the in-memory fake server and fake sign-in, with an in-memory store; no network
#
# The simulator is TOMI_SIMULATOR, by name (default "iPhone 17"). It is booted if it is not running.
set -eu
cd "$(dirname "$0")/.."

MODE="${1:-cloud}"
[ $# -gt 0 ] && shift
case "$MODE" in
    cloud) MODE_ARGUMENTS="" ;;
    local) MODE_ARGUMENTS="--local-backend" ;;
    fake) MODE_ARGUMENTS="--fake-backend --store-in-memory" ;;
    *) echo "Unknown mode \"$MODE\". Use cloud, local or fake." >&2; exit 2 ;;
esac

SIMULATOR="${TOMI_SIMULATOR:-iPhone 17}"
DERIVED_DATA=build/DerivedData
BUNDLE_ID=com.mrspacerobot.tomi

UDID=$(xcrun simctl list devices available | grep -F "    $SIMULATOR (" | head -1 | sed -E 's/.*\(([0-9A-F-]{36})\).*/\1/')
if [ -z "$UDID" ]; then
    echo "No available simulator named \"$SIMULATOR\"." >&2
    exit 1
fi
xcrun simctl boot "$UDID" 2>/dev/null || true

echo "== Building for $SIMULATOR"
xcodebuild -project Tomi.xcodeproj -scheme Tomi -destination "id=$UDID" -derivedDataPath "$DERIVED_DATA" -quiet build

echo "== Launching ($MODE)"
xcrun simctl install "$UDID" "$DERIVED_DATA/Build/Products/Debug-iphonesimulator/Tomi.app"
xcrun simctl terminate "$UDID" "$BUNDLE_ID" 2>/dev/null || true
# Word splitting of MODE_ARGUMENTS is intended: it holds zero or more arguments.
# shellcheck disable=SC2086
xcrun simctl launch "$UDID" "$BUNDLE_ID" $MODE_ARGUMENTS "$@"
