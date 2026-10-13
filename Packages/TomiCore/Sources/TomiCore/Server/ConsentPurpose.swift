/// Something the cook can agree to, each on its own. The raw values are the server's names in its URLs.
public enum ConsentPurpose: String, CaseIterable, Hashable, Codable, Sendable {
    /// A fridge photo is sent to the server to be read, then dropped. Needed before the first scan.
    case photoScan = "photo-scan"
    /// The photo is kept as it was sent, with its place, time and what was seen. A separate choice, off until agreed.
    case photoDataset = "photo-dataset"
}
