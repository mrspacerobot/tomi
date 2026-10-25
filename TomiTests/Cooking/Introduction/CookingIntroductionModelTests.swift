import Foundation
import Testing
import TomiCore

@testable import Tomi

@Suite @MainActor struct CookingIntroductionModelTests {
    @Test func currentRestrictionsAllowPreparation() async throws {
        let profile = CookProfile()
        let suggestion = try guidedSuggestion(checkedFor: profile)
        let model = CookingIntroductionModel(suggestion: suggestion, profile: ImmediateProfileReader(profile))
        #expect(await model.prepare() == .ready)
    }

    @Test func cancelledIntroductionCannotStartWhenDelayedProfileReturns() async throws {
        let profile = CookProfile()
        let suggestion = try guidedSuggestion(checkedFor: profile)
        let reader = DelayedProfileReader()
        let model = CookingIntroductionModel(suggestion: suggestion, profile: reader)
        let task = Task { await model.prepare() }
        await reader.waitUntilRequested()
        model.cancel()
        task.cancel()
        reader.resume(with: profile)
        #expect(await task.value == .cancelled)
    }

    @Test func aChangedRestrictionRefusesPreparation() async throws {
        let initial = CookProfile()
        let suggestion = try guidedSuggestion(checkedFor: initial)
        var changed = initial
        changed.diet = "fake-changed-diet"
        let model = CookingIntroductionModel(suggestion: suggestion, profile: ImmediateProfileReader(changed))
        #expect(await model.prepare() == .restrictionsChanged)
    }

    @Test func removedAvoidItemRequiresNewSuggestionsBeforePreparation() async throws {
        var checked = CookProfile()
        checked.avoid = ["fake-avoid"]
        let suggestion = try guidedSuggestion(checkedFor: checked)
        let latest = CookProfile()
        let model = CookingIntroductionModel(suggestion: suggestion, profile: ImmediateProfileReader(latest))
        #expect(suggestion.isChecked(for: latest))
        #expect(await model.prepare() == .restrictionsChanged)
    }

    @Test func unavailableTeachingDoesNotFetchProfile() async throws {
        let profile = CookProfile()
        let lesson = try #require(BundledLessonLibrary().lessons.first)
        let suggestion = try FakeSuggestion(lesson: lesson, wantsSwap: false).suggestion(checkedFor: profile)
        let reader = CountingProfileReader(profile)
        let model = CookingIntroductionModel(suggestion: suggestion, profile: reader)
        #expect(await model.prepare() == .unavailable)
        #expect(reader.reads == 0)
    }

    private func guidedSuggestion(checkedFor profile: CookProfile) throws -> Suggestion {
        try FakeGuidedSuggestion.read(profile: profile)
    }
}

@MainActor private final class CountingProfileReader: FreshProfileReading {
    let profile: CookProfile
    private(set) var reads = 0

    init(_ profile: CookProfile) { self.profile = profile }

    func refreshProfile() async throws -> CookProfile {
        reads += 1
        return profile
    }
}

@MainActor private final class DelayedProfileReader: FreshProfileReading {
    private var request: CheckedContinuation<CookProfile, any Error>?
    private var started: CheckedContinuation<Void, Never>?

    func refreshProfile() async throws -> CookProfile {
        try await withCheckedThrowingContinuation { continuation in
            request = continuation
            started?.resume()
            started = nil
        }
    }

    func waitUntilRequested() async {
        if request != nil { return }
        await withCheckedContinuation { started = $0 }
    }

    func resume(with profile: CookProfile) {
        request?.resume(returning: profile)
        request = nil
    }
}

@MainActor private struct ImmediateProfileReader: FreshProfileReading {
    let profile: CookProfile

    init(_ profile: CookProfile) { self.profile = profile }

    func refreshProfile() async throws -> CookProfile { profile }
}
