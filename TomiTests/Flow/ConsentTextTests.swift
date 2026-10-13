import Testing
import TomiCore

@testable import Tomi

/// Each consent is its own text with its own version, which must match the server's for that purpose.
@Suite struct ConsentTextTests {
    @Test func eachPurposeHasItsOwnTextVersion() {
        #expect(ConsentText.version(for: .photoScan) == 1)
        #expect(ConsentText.version(for: .photoDataset) == 2)
    }

    @Test func aStatusIsCurrentOnlyAtItsOwnPurposesVersion() {
        let current = ConsentStatus(purpose: .photoDataset, currentVersion: 2, agreed: false)
        let old = ConsentStatus(purpose: .photoDataset, currentVersion: 1, agreed: false)
        let scanAtDatasetVersion = ConsentStatus(purpose: .photoScan, currentVersion: 2, agreed: false)
        #expect(ConsentText.isCurrent(current))
        #expect(!ConsentText.isCurrent(old))
        #expect(!ConsentText.isCurrent(scanAtDatasetVersion))
    }
}
