import TomiCore

/// The consent texts the app shows live in the string catalog. These are the versions of those texts, one per
/// purpose, which must match the server's `currentVersion` for that purpose: agreeing to an older text than the
/// server's would not count. Once the app is released, raise a purpose's version, with the server's, when its
/// text changes in substance. Before release a text changes in place.
nonisolated enum ConsentText {
    static func version(for purpose: ConsentPurpose) -> Int {
        switch purpose {
        case .photoScan: 1
        case .photoDataset: 1
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
