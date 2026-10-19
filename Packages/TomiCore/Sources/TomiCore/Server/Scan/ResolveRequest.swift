/// The body of `POST /v1/ingredients/resolve`: what the cook typed, one entry per thing.
public struct ResolveRequest: Hashable, Codable, Sendable {
    public let labels: [String]

    public init(labels: [String]) {
        self.labels = labels
    }
}
