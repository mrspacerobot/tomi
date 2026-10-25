import Foundation
import Observation
import TomiCore

/// Rechecks the latest server profile before preparation can begin.
@MainActor @Observable
final class CookingIntroductionModel {
    let suggestion: Suggestion
    private let profile: any FreshProfileReading
    private(set) var isRefreshingProfile = false
    private var isCurrent = true

    init(suggestion: Suggestion, profile: any FreshProfileReading) {
        self.suggestion = suggestion
        self.profile = profile
    }

    func prepare() async -> CookingIntroductionStartResult {
        guard suggestion.canOfferTeaching else { return .unavailable }
        isRefreshingProfile = true
        defer { isRefreshingProfile = false }
        do {
            let latest = try await profile.refreshProfile()
            guard isCurrent, !Task.isCancelled else { return .cancelled }
            return result(for: latest)
        } catch {
            return refreshFailureResult()
        }
    }

    private func refreshFailureResult() -> CookingIntroductionStartResult {
        if !isCurrent || Task.isCancelled { return .cancelled }
        return .profileUnavailable
    }

    func cancel() { isCurrent = false }

    func activate() { isCurrent = true }

    private func result(for latest: CookProfile) -> CookingIntroductionStartResult {
        if suggestion.isChecked(for: latest), suggestion.checked.avoid == latest.avoid { return .ready }
        return .restrictionsChanged
    }
}
