import TomiCore

/// The consent texts the app shows live in the string catalog. These are the versions of those texts, one per
/// purpose, which must match the server's `currentVersion` for that purpose: agreeing to an older text than the
/// server's would not count. Raise a purpose's version when its text changes in substance, with the server's.
nonisolated enum ConsentText {
    /// The photo-scan text is unchanged since the start. The photo-dataset text is version 2: it says a kept
    /// photo keeps its place and time, which version 1 promised it did not.
    static func version(for purpose: ConsentPurpose) -> Int {
        switch purpose {
        case .photoScan: 1
        case .photoDataset: 2
        }
    }

    /// Whether the app has the text the server asks the cook to agree to for this status's purpose.
    /// A purpose this build does not know has no text here, so it is never current.
    static func isCurrent(_ status: ConsentStatus) -> Bool {
        guard let purpose = status.purpose else {
            return false
        }
        return status.currentVersion == version(for: purpose)
    }
}
