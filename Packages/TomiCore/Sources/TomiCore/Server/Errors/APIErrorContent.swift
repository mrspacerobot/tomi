/// The inside of an error body. Only the details the app acts on are read.
struct APIErrorContent: Decodable {
    let code: String
    let message: String
    let details: APIErrorDetails?
}
