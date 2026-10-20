# The app icon

The home-screen icon is Tomi as the app draws him, not a separate picture. iOS only takes an app icon as an image, so the image is rendered from the same SwiftUI parts as `TomiMascot` and `TomiCompanion` and kept in the asset catalog.

- `Tomi/DesignSystem/AppIcon/AppIconArtwork.swift` draws the icon: Tomi at rest, his head and toque large, on the `wash` colour of the disc behind him on the welcome screen.
- `AppIconFraming` says which square of `CompanionGrid` the icon shows.
- `AppIconAppearance` gives the three looks iOS 27 asks for: light (light tokens), dark (dark tokens) and tinted (the dark icon in grey, which iOS colours itself).
- `Tomi/Resources/Assets.xcassets/AppIcon.appiconset` holds `AppIcon.png`, `AppIcon-Dark.png` and `AppIcon-Tinted.png`, 1024 by 1024, with no transparency. Never edit them by hand.

## Rendering it again

After a change to Tomi's drawing, his colours or the icon's framing:

```
./scripts/render-app-icon.sh
```

It runs `AppIconExportTests` in the simulator with `TOMI_RENDER_APP_ICON=1`, which writes the three files into the icon set. Set `TOMI_DESTINATION` to pick a simulator, as for `./scripts/check.sh`. Then look at the files at full size and shrunk to 60 points, install the app and look at the home screen in light, dark and tinted, and commit the files with the change that caused them.

`AppIconRenderingTests` runs in every check. It fails when the drawing cannot be rendered, when an appearance is not an opaque 1024 by 1024 square, and when a shipped file no longer matches the drawing pixel for pixel, so a change to Tomi, a colour token or the framing that forgets the icon does not pass, even if it moves one colour by one level. The comparison has no tolerance: the test draws the icon with Core Graphics on the CPU, which gives the same bytes on every run. After an Xcode or iOS update changes how Core Graphics smooths edges, the test fails once, and rendering the icon again fixes it.

## Why an asset catalog and not Icon Composer

Icon Composer's `.icon` builds an icon from layers and lets iOS add Liquid Glass and work out the dark and tinted looks. Tomi is one flat cartoon with his own dark colours, so a single rendered layer per appearance in the asset catalog keeps him exactly as the app draws him and needs no hand-made layer file.
