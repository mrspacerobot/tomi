import Foundation

/// Contrast as the Web Content Accessibility Guidelines 2 define it, so the numbers match the design's.
extension RGBColor {
    /// How bright the colour looks, from 0 (black) to 1 (white).
    public var relativeLuminance: Double {
        0.2126 * Self.linear(red) + 0.7152 * Self.linear(green) + 0.0722 * Self.linear(blue)
    }

    /// From 1 (the same colour) to 21 (black on white). The order of the two colours does not matter.
    public func contrastRatio(with other: RGBColor) -> Double {
        let lighter = max(relativeLuminance, other.relativeLuminance)
        let darker = min(relativeLuminance, other.relativeLuminance)
        return (lighter + 0.05) / (darker + 0.05)
    }

    /// Undoes the gamma curve of sRGB, so that brightness can be added up.
    private static func linear(_ part: Double) -> Double {
        if part <= 0.04045 {
            return part / 12.92
        }
        return pow((part + 0.055) / 1.055, 2.4)
    }
}
