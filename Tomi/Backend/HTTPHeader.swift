/// Header names and values the app sends, written once.
nonisolated enum HTTPHeader {
    static let authorization = "Authorization"
    static let acceptLanguage = "Accept-Language"
    static let contentType = "Content-Type"
    static let apiKey = "apikey"
    static let json = "application/json"
    static let jpeg = "image/jpeg"

    static func bearer(_ token: String) -> String {
        "Bearer " + token
    }
}
