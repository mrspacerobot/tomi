/// A colour of text and the ground it is set on. A test checks every pairing can be read in light and dark.
nonisolated struct TextPairing: Hashable, Sendable {
    let text: ColorRole
    let ground: ColorRole
}
