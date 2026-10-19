#!/bin/sh
# Archives a Release build and uploads it to App Store Connect for TestFlight. See AGENTS.md.
#
#   scripts/testflight.sh
#
# Needs the owner's Apple account signed in to Xcode (Settings > Accounts) and the app created in
# App Store Connect with the bundle id com.mrspacerobot.tomi. Signing is automatic for the team in the project.
# Each upload needs a build number App Store Connect has not seen, so it is taken from the clock.
set -eu
cd "$(dirname "$0")/.."

BUILD_NUMBER=$(date -u +%Y%m%d%H%M)
ARCHIVE=build/Tomi.xcarchive
EXPORT=build/TestFlight

echo "== Archiving build $BUILD_NUMBER"
rm -rf "$ARCHIVE" "$EXPORT"
xcodebuild -project Tomi.xcodeproj -scheme Tomi -configuration Release -destination "generic/platform=iOS" \
    -archivePath "$ARCHIVE" -allowProvisioningUpdates -quiet \
    CURRENT_PROJECT_VERSION="$BUILD_NUMBER" archive

echo "== Uploading to App Store Connect"
xcodebuild -exportArchive -archivePath "$ARCHIVE" -exportPath "$EXPORT" \
    -exportOptionsPlist Config/TestFlightExportOptions.plist -allowProvisioningUpdates

echo "Uploaded build $BUILD_NUMBER. It shows in TestFlight once App Store Connect has processed it."
