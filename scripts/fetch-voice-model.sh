#!/bin/sh
# Fetches the Kokoro voice model that ships inside the app (about 100 MB) into a cache outside the checkout
# (TOMI_VOICE_MODEL_CACHE), then copies it into Tomi/Resources/Voice/Models. A clean checkout deletes ignored
# files, so only the cache lets the download happen once.
# Every file comes from one pinned revision and is checked against scripts/voice-model.manifest, so the voice
# is the same on every machine. The folder is not in git. Safe to run again: files that already match are kept.
# To update the model, change REVISION, regenerate the manifest (see docs/voice-model.md) and run this script.
set -eu
cd "$(dirname "$0")/.."

REVISION="006395f65025af251858b1ab0a7178a6a1e73f9f"
REPOSITORY="https://huggingface.co/FluidInference/kokoro-82m-coreml/resolve/$REVISION"
DESTINATION="${TOMI_VOICE_MODEL_DIR:-Tomi/Resources/Voice/Models}"
CACHE="${TOMI_VOICE_MODEL_CACHE:-$HOME/Library/Caches/Tomi/voice-model}"
MANIFEST="scripts/voice-model.manifest"

matches() {
    [ -f "$2" ] && [ "$(shasum -a 256 "$2" | cut -d ' ' -f 1)" = "$1" ]
}

fetch() {
    expected="$1"; area="$2"; path="$3"
    target="$CACHE/$path"
    if matches "$expected" "$target"; then
        return
    fi
    mkdir -p "$(dirname "$target")"
    if [ "$area" = "ANE" ]; then url="$REPOSITORY/ANE/$path"; else url="$REPOSITORY/$path"; fi
    curl --fail --silent --show-error --location "$url" --output "$target"
    if ! matches "$expected" "$target"; then
        echo "Checksum mismatch for $path" >&2
        rm -f "$target"
        exit 1
    fi
}

echo "== Voice model"
while read -r expected area path; do
    fetch "$expected" "$area" "$path"
done < "$MANIFEST"
mkdir -p "$DESTINATION"
rsync -a "$CACHE/" "$DESTINATION/"
echo "Voice model ready in $DESTINATION"
