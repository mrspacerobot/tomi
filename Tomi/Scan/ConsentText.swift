import TomiCore

/// The consent texts the app shows live in the string catalog. This is the version of those texts, which must
/// match the server's `currentVersion`: agreeing to an older text than the server's would not count.
enum ConsentText {
    static let version = 1

    /// Whether the app has the text the server asks the cook to agree to.
    static func isCurrent(_ status: ConsentStatus) -> Bool {
        status.currentVersion == version
    }
}
