import TomiCore

/// A request and the account that owns the cook, kept together across suspension points.
struct OwnedCookRequest {
    let request: CookEntryRequest
    let account: String
}
