/// What `POST /v1/scans` sends back for a fridge photo.
public struct ScanResult: Hashable, Codable, Sendable {
    public let scanID: ScanID
    /// Whether the server kept the photo. Proof of concept: it keeps every photo when its photo storage is set up.
    public let kept: Bool
    public let items: [ScanItem]

    public init(scanID: ScanID, kept: Bool, items: [ScanItem]) {
        self.scanID = scanID
        self.kept = kept
        self.items = items
    }

    enum CodingKeys: String, CodingKey {
        case scanID = "scanId"
        case kept
        case items
    }
}
