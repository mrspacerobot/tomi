import Foundation
import Testing

@testable import TomiCore

/// Every error of the server has one layout. The app acts on the code and shows the message when it must.
@Suite struct APIErrorTests {
    func error(_ text: String) -> APIError? {
        APIError.decode(from: Data(text.utf8))
    }

    @Test func aKnownCodeAndItsMessageAreRead() {
        let decoded = error(#"{"error": {"code": "ai_unavailable", "message": "Type instead."}}"#)
        #expect(decoded?.code == .aiUnavailable)
        #expect(decoded?.message == "Type instead.")
        #expect(decoded?.currentProfile == nil)
    }

    @Test func theGraphBeingUnavailableIsAKnownCode() {
        let decoded = error(#"{"error": {"code": "graph_unavailable", "message": "No graph."}}"#)
        #expect(decoded?.code == .graphUnavailable)
    }

    @Test func aChangedGraphVersionIsAKnownCode() {
        let decoded = error(#"{"error": {"code": "graph_version_changed", "message": "New graph."}}"#)
        #expect(decoded?.code == .graphVersionChanged)
    }

    @Test func anUnknownCodeIsKeptWithItsMessage() {
        let decoded = error(#"{"error": {"code": "teapot", "message": "Short and stout."}}"#)
        #expect(decoded?.code == nil)
        #expect(decoded?.codeName == "teapot")
        #expect(decoded?.message == "Short and stout.")
    }

    @Test func aVersionConflictCarriesTheProfileAsItIsNow() {
        let text =
            #"{"error": {"code": "version_conflict", "message": "Changed.", "details": {"current": "#
            + #"{"version": 4, "schemaVersion": 1, "profile": {"diet": "vegan", "avoid": ["nuts"]}}}}}"#
        let current = error(text)?.currentProfile
        #expect(current?.version == 4)
        #expect(current?.profile.diet == "vegan")
        #expect(current?.profile.avoid == ["nuts"])
    }

    @Test func detailsThatCannotBeReadDoNotLoseTheError() {
        let text =
            #"{"error": {"code": "ai_unavailable", "message": "The model is away.", "#
            + #""details": {"something": "unexpected"}}}"#
        #expect(error(text)?.code == .aiUnavailable)
    }

    @Test(arguments: ["", "not json", #"{"code": "internal"}"#])
    func aBodyThatIsNotAnErrorIsNone(text: String) {
        #expect(error(text) == nil)
    }
}
