/// Something the cook can agree to, each on its own. The raw values are the server's names in its URLs.
public enum ConsentPurpose: String, CaseIterable, Hashable, Codable, Sendable {
    /// A fridge photo is sent to the server to be read, then dropped. Needed before the first scan.
    case photoScan = "photo-scan"
    /// The photo, without its metadata, is kept with what was seen in it. A separate choice, off until agreed.
    case photoDataset = "photo-dataset"
}
