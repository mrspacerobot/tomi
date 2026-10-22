#!/bin/sh
# Renders the app icon from Tomi's SwiftUI drawing into the asset catalog, in light, dark and tinted.
# See docs/app-icon.md.
set -eu
cd "$(dirname "$0")/.."

DESTINATION="${TOMI_DESTINATION:-platform=iOS Simulator,name=iPhone 17}"

# Xcode hands variables starting with TEST_RUNNER_ to the tests, without the prefix.
TEST_RUNNER_TOMI_RENDER_APP_ICON=1 xcodebuild -project Tomi.xcodeproj -scheme Tomi -destination "$DESTINATION" \
    -derivedDataPath build/DerivedData -only-testing:TomiTests/AppIconExportTests \
    -collect-test-diagnostics never -quiet test

echo "Rendered Tomi/Resources/Assets.xcassets/AppIcon.appiconset. Look at it before you commit."
