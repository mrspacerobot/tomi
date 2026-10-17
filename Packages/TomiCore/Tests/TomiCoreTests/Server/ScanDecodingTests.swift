import Testing

@testable import TomiCore

/// What `POST /v1/scans` sends back, and which items start ticked on the list the cook confirms.
@Suite struct ScanDecodingTests {
    static let scan =
        #"{"scanId": "scan-1", "kept": false, "items": ["#
        + #"{"label": "eggs", "ingredient": {"id": "egg", "name": "Egg"}, "confidence": 0.9}, "#
        + #"{"label": "a jar of pesto", "ingredient": null, "confidence": 0.7}]}"#

    @Test func theScanIsReadWithItsItems() throws {
        let result = try ServerJSON.decode(ScanResult.self, from: Self.scan)
        #expect(result.scanID == "scan-1")
        #expect(!result.kept)
        #expect(result.items.map(\.label) == ["eggs", "a jar of pesto"])
        #expect(result.items.first?.ingredient == NamedOption(id: "egg", name: "Egg"))
        #expect(result.items.last?.ingredient == nil)
    }

    @Test func aSureMatchStartsTicked() {
        let egg = ScanItem(label: "eggs", ingredient: NamedOption(id: "egg", name: "Egg"), confidence: 0.9)
        #expect(egg.startsTicked)
    }

    /// Unsure ingredients are not counted until the cook confirms them.
    @Test func anUnsureMatchStartsUnticked() {
        let below = ScanItem.sureConfidence - 0.01
        let egg = ScanItem(label: "eggs?", ingredient: NamedOption(id: "egg", name: "Egg"), confidence: below)
        #expect(!egg.startsTicked)
    }

    @Test func anItemThatMatchedNoIngredientStartsUnticked() {
        #expect(!ScanItem(label: "a jar of pesto", ingredient: nil, confidence: 1).startsTicked)
    }
}
