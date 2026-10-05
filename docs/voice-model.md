# Tomi's voice model

Tomi speaks with Kokoro-82M, a neural voice that runs on the phone (#96). The model ships inside the app,
so speech works with no network.

## What ships

- About 100 MB of Core ML model and text files from `FluidInference/kokoro-82m-coreml` on Hugging Face,
  fetched by `scripts/fetch-voice-model.sh` into `Tomi/Resources/Voice/Models`. That folder is not in git.
  The script reads one pinned revision and checks every file against `scripts/voice-model.manifest`.
  `./scripts/check.sh` runs it first. Run it by hand before building the app in Xcode.
- `Tomi/Resources/Voice/am_fenrir.bin` (0.5 MB), the voice, which is in git. The repository only offers
  this voice as a JSON file, so the engine converted it once. It is the voice named in `voice.json`.
- `Tomi/Resources/Voice/kokoro-files.json`, which says which shipped file goes in which folder. Xcode puts
  every resource side by side in the app, but the engine looks in two folders, so `KokoroModelFiles` links
  each file into place at the first spoken line.

Without the fetched files the app still works: the engine downloads them when it can, and otherwise
the system voice speaks.

## Changing the voice

1. Put the new voice in `voice.json`.
2. Make its `.bin`: run `fluidaudiocli tts "Hello" --backend kokoro-ane --voice <name> --output out.wav` from
   the FluidAudio package at the version in the project, then copy `<name>.bin` from
   `~/.cache/fluidaudio/Models/kokoro-82m-coreml/ANE/` to `Tomi/Resources/Voice/`.
3. List it in `kokoro-files.json`. A test fails if the voice in `voice.json` is not among the shipped files.

## Updating the model

Change `REVISION` in the script, regenerate `scripts/voice-model.manifest` (a SHA-256, the area `ANE` or
`root`, and the path for every file), run the script, and listen again. Licenses: FluidAudio is Apache-2.0,
Kokoro-82M is Apache-2.0. The files on Hugging Face are converted by FluidInference, so check their model
card before shipping a new revision.
