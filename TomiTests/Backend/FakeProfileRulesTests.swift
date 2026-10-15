import Testing
import TomiCore

@testable import Tomi

/// The fake server refuses what the real one refuses, so UI tests meet the same errors.
@Suite struct FakeProfileRulesTests {
    private let options = FakeServerData(library: BundledLessonLibrary()).options

    private func rules() -> FakeProfileRules {
        FakeProfileRules(
            stored: ProfileEnvelope(version: 0, schemaVersion: 2, profile: CookProfile()),
            options: options
        )
    }

    @Test func aStapleTheGraphDoesNotKnowIsRefused() {
        var after = CookProfile()
        after.cupboardStaples = ["no-such-ingredient"]
        let patch = ProfilePatch(version: 0, before: CookProfile(), after: after)
        #expect(throws: BackendError.self) {
            try rules().check(patch)
        }
    }

    @Test func everyStapleOfTheOptionsIsAccepted() throws {
        var after = CookProfile()
        after.cupboardStaples = Set(options.staples.map(\.id))
        try rules().check(ProfilePatch(version: 0, before: CookProfile(), after: after))
    }
}
