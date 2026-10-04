/// How much contrast text needs against its ground before a cook can read it.
public enum ContrastRule {
    /// The minimum for body text in the Web Content Accessibility Guidelines, level AA.
    public static let minimumForBodyText = 4.5

    public static func isReadableAsBodyText(_ text: RGBColor, on ground: RGBColor) -> Bool {
        text.contrastRatio(with: ground) >= minimumForBodyText
    }
}
