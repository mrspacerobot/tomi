import TomiCore

/// Reads the bundled graph suggestion fixture used by cooking previews.
enum PreviewSuggestion {
    static func make() -> Suggestion? {
        try? FakeGuidedSuggestion.read(profile: CookProfile())
    }
}
