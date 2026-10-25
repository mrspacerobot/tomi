extension OptionID {
    /// A graph id as plain words, for the one case where the server sent no name: `ingredient/olive-oil`
    /// becomes `olive oil`. It is a fallback so the cook sees something, never a translation.
    public var readable: String {
        let name = rawValue.split(separator: "/").last ?? Substring(rawValue)
        return String(name).replacing("-", with: " ")
    }
}
