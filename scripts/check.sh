#!/bin/sh
# Runs every check a change must pass before it is called done. See AGENTS.md.
set -eu
cd "$(dirname "$0")/.."

DESTINATION="${TOMI_DESTINATION:-platform=iOS Simulator,name=iPhone 17}"

echo "== Format and lint"
xcrun swift-format lint --strict --recursive Tomi TomiTests TomiUITests Packages/TomiCore

echo "== Size limits, hard-coded text and other lint rules"
swiftlint lint --strict --quiet

echo "== Rules package tests"
swift test --package-path Packages/TomiCore

echo "== App build, unit tests and UI tests"
# Without "never", every failing UI test makes the simulator collect a sysdiagnose, which can sit for ten
# minutes before the failure is reported. The test output already names what failed.
xcodebuild -project Tomi.xcodeproj -scheme Tomi -destination "$DESTINATION" \
    -derivedDataPath build/DerivedData -collect-test-diagnostics never -quiet test

echo "All checks passed."
