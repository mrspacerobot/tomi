import Foundation
import Testing

@testable import TomiCore

/// The consents of `GET /v1/consents` and the body that agrees to one.
@Suite struct ConsentTests {
    @Test func theConsentsAreReadWithTheirPurposeAndVersion() throws {
        let text =
            #"[{"purpose": "photo-scan", "currentVersion": 1, "agreed": true}, "#
            + #"{"purpose": "photo-dataset", "currentVersion": 2, "agreed": false}]"#
        let consents = try ServerJSON.decode([ConsentStatus].self, from: text)
        #expect(
            consents == [
                ConsentStatus(purpose: .photoScan, currentVersion: 1, agreed: true),
                ConsentStatus(purpose: .photoDataset, currentVersion: 2, agreed: false),
            ]
        )
    }

    @Test func aPurposeThisBuildDoesNotKnowIsKeptButHasNoPurpose() throws {
        let text = #"[{"purpose": "voice-dataset", "currentVersion": 1, "agreed": false}]"#
        let consents = try ServerJSON.decode([ConsentStatus].self, from: text)
        #expect(consents.first?.purpose == nil)
    }

    @Test func thePurposesUseTheServersNames() {
        #expect(ConsentPurpose.allCases.map(\.rawValue) == ["photo-scan", "photo-dataset"])
    }

    @Test func anAgreementNamesTheVersionShown() throws {
        let text = String(bytes: try JSONEncoder().encode(ConsentAgreement(version: 1)), encoding: .utf8)!
        #expect(text == #"{"version":1}"#)
    }
}
