import SwiftUI

/// The design tokens that paint Tomi, read once per drawing. The canvas resolves each for light or dark.
struct CompanionPalette {
    let tomato: Color
    let shade: Color
    let line: Color
    let feature: Color
    let toque: Color
    let white: Color
    let shoe: Color
    let blush: Color
    let glow: Color
    let sparkle: Color

    static var tokens: CompanionPalette {
        CompanionPalette(
            tomato: ColorRole.printRed.color,
            shade: ColorRole.companionShade.color,
            line: ColorRole.companionLine.color,
            feature: ColorRole.companionFeature.color,
            toque: ColorRole.companionToque.color,
            white: ColorRole.companionWhite.color,
            shoe: ColorRole.companionShoe.color,
            blush: ColorRole.companionBlush.color,
            glow: ColorRole.companionGlow.color,
            sparkle: ColorRole.yolk.color
        )
    }
}
