# Tomi's voice model

Tomi speaks with Kokoro-82M, a neural voice that runs on the phone (#96). The model ships inside the app,
so speech works with no network.

## What ships

- About 100 MB of Core ML model and text files from `FluidInference/kokoro-82m-coreml` on Hugging Face,
  fetched by `scripts/fetch-voice-model.sh` into `Tomi/Resources/Voice/Models`. That folder is not in git.
  The script reads one pinned revision and checks every file against `scripts/voice-model.manifest`.
  It downloads into a cache outside the checkout (`~/Library/Caches/Tomi/voice-model`, or
  `TOMI_VOICE_MODEL_CACHE`) and copies from there, because a clean checkout deletes ignored files.
  `./scripts/check.sh` runs it first. Run it by hand before building the app in Xcode.
- `Tomi/Resources/Voice/am_fenrir.bin` (0.5 MB), the voice, which is in git. The repository only offers
  this voice as a JSON file, so the engine converted it once. It is the voice named in `voice.json`.
- `Tomi/Resources/Voice/kokoro-files.json`, which says which shipped file goes in which folder. Xcode puts
  every resource side by side in the app, but the engine looks in two folders, so `KokoroModelFiles` links
  each file into place at the first spoken line.

Without the fetched files the app still works: the engine downloads them when it can, and otherwise
the system voice speaks.

## When it is fetched, cached and built in

- **Fetched:** only by `scripts/fetch-voice-model.sh`. `./scripts/check.sh` runs it first, so it runs on your
  Mac before a pull request and again in the "Check" on every pull request. Xcode never runs it: before the
  first build in Xcode, and before an archive for the App Store, run it by hand.
- **Cached:** the download lands in `~/Library/Caches/Tomi/voice-model`, outside the checkout. The "Check"
  runs on the owner's Mac, so its cache stays between runs and nothing is downloaded again. Every run still
  compares all files with the manifest and copies them into the app folder, which takes a second or two.
- **Built into the app:** yes. Whatever is in `Tomi/Resources/Voice/Models` when Xcode builds goes into the
  app, and the phone downloads nothing. A unit test (`theShippedAppCarriesEveryFileOfTheLayout`) fails when
  the built app lacks a file, so a green check proves the model is inside. An archive made without a check
  is not guarded: if the folder is empty the app still builds, and the phone then downloads the model or
  falls back to the system voice. There is no release workflow yet; when there is one, it runs the script
  and the check before it archives.
- **When to update:** nothing tells us, on purpose. The revision is pinned, so the model changes only when
  a person changes it. Two reasons to do so: FluidAudio is moved to a new version that expects other files
  (its version is pinned too, in the project), or FluidInference publishes a better conversion we want.
  Either way follow "Updating the model" below and listen to the result before it ships.

## Changing the engine

`voice.json` names the engine (`kokoro` or `system`) and the voice. `VoiceEngine` lists the engines and
`VoiceService` builds the speaker for each, always with the system voice behind it. To add an engine, write
a `Speaker` for it, add a case to `VoiceEngine` and a line to `VoiceService`, then name it in `voice.json`.
No screen changes, because screens only know the `Speaker` protocol.

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
