import TomiCore

/// Where the fridge scan is.
enum ScanStage: Equatable {
    /// The cook picks a photo, or types instead.
    case ready
    case reading
    /// The cook ticks, unticks and types what they have tonight.
    case confirming
    case finding
    case menu(TonightsMenu)
    /// The server had nothing the cook can cook yet. Not an error.
    case nothingTonight
}
