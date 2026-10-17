/// The layout of every error body of the server: `{"error": {...}}`.
struct APIErrorBody: Decodable {
    let error: APIErrorContent
}
