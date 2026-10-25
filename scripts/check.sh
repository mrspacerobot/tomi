#!/bin/sh
# Runs every check a change must pass before it is called done. See AGENTS.md.
set -eu
cd "$(dirname "$0")/.."

DESTINATION="${TOMI_DESTINATION:-platform=iOS Simulator,name=iPhone 17}"

echo "== Voice model (fetched once, about 100 MB)"
./scripts/fetch-voice-model.sh

echo "== Format and lint"
xcrun swift-format lint --strict --recursive Tomi TomiTests TomiUITests Packages/TomiCore

echo "== Size limits, hard-coded text and other lint rules"
swiftlint lint --strict --quiet

echo "== Rules package tests"
swift test --package-path Packages/TomiCore

echo "== App build, unit tests and UI tests"
# Without "never", every failing UI test makes the simulator collect a sysdiagnose, which can sit for ten
# minutes before the failure is reported. The test output already names what failed.
# Xcode gives each parallel worker its own simulator clone, isolating appearance and test stores.
xcodebuild -project Tomi.xcodeproj -scheme Tomi -destination "$DESTINATION" \
    -derivedDataPath build/DerivedData -parallel-testing-enabled YES \
    -maximum-parallel-testing-workers 2 -maximum-concurrent-test-simulator-destinations 2 \
    -collect-test-diagnostics never -quiet test

echo "All checks passed."
