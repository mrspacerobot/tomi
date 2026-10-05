import SwiftUI

/// Which colour role paints which part of Tomi. Print style: the outline is cobalt on paper and paper on
/// night ink, and the toque is left as the ground in light and filled with paper in dark.
struct MascotPalette {
    let outline: ColorRole
    let toque: ColorRole
    let toqueOutline: ColorRole
    let eye: ColorRole
    let face: ColorRole

    static let light = MascotPalette(outline: .cobalt, toque: .paper, toqueOutline: .cobalt, eye: .paper, face: .ink)
    static let dark = MascotPalette(outline: .ink, toque: .ink, toqueOutline: .paper, eye: .ink, face: .paper)

    static func palette(for scheme: ColorScheme) -> MascotPalette {
        if scheme == .dark {
            return dark
        }
        return light
    }
}
