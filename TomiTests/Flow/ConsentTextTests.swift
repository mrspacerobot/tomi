import Foundation
import Testing
import TomiCore

@testable import Tomi

/// Each consent is its own text with its own version, which must match the server's for that purpose.
@Suite struct ConsentTextTests {
    @Test func theTextVersionsAreTheServers() {
        #expect(ConsentText.version(for: .photoScan) == 1)
        #expect(ConsentText.version(for: .photoDataset) == 1)
    }

    @Test func aStatusIsCurrentOnlyAtItsPurposesVersion() throws {
        let current = ConsentStatus(purpose: .photoDataset, currentVersion: 1, agreed: false)
        let newer = ConsentStatus(purpose: .photoDataset, currentVersion: 2, agreed: false)
        let text = #"{"purpose": "photo-future", "currentVersion": 1, "agreed": false}"#
        let unknown = try JSONDecoder().decode(ConsentStatus.self, from: Data(text.utf8))
        #expect(ConsentText.isCurrent(current))
        #expect(!ConsentText.isCurrent(newer))
        #expect(!ConsentText.isCurrent(unknown))
    }
}
