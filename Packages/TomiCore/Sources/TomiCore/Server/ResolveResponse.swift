/// What `POST /v1/ingredients/resolve` sends back, one result for each typed word, in the same order.
public struct ResolveResponse: Hashable, Codable, Sendable {
    public let results: [ResolvedLabel]

    public init(results: [ResolvedLabel]) {
        self.results = results
    }
}
