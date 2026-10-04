/// Content text from the library in every language it was written in, keyed by language code ("en", "pt-BR").
/// Screen text lives in the app's string catalog; this is for words that arrive with the content.
public struct LocalizedText: Hashable, Codable, Sendable {
    /// The language every piece of content must have, and the fallback for all others.
    public static let sourceLanguage = "en"

    public let translations: [String: String]

    public init(_ translations: [String: String]) {
        self.translations = translations
    }

    public init(from decoder: any Decoder) throws {
        translations = try decoder.singleValueContainer().decode([String: String].self)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(translations)
    }

    public var isMissingSourceText: Bool {
        guard let sourceText = translations[Self.sourceLanguage] else {
            return true
        }
        return sourceText.isBlank
    }

    /// The best text for the cook's languages, in order of preference (pass `Locale.preferredLanguages`).
    public func resolved(preferredLanguages: [String]) -> String {
        let candidates = preferredLanguages.flatMap(candidates(for:)) + [Self.sourceLanguage]
        return candidates.lazy.compactMap { translations[$0] }.first ?? ""
    }

    /// The language itself, then its base, then any other region of it, as Apple's own localization lookup does:
    /// a Portuguese cook would rather read Brazilian Portuguese than their second language.
    private func candidates(for language: String) -> [String] {
        let base = baseLanguage(of: language)
        let otherRegions = translations.keys.filter { baseLanguage(of: $0) == base }.sorted()
        return [language, base] + otherRegions
    }

    private func baseLanguage(of language: String) -> String {
        String(language.prefix { $0 != "-" && $0 != "_" })
    }
}
