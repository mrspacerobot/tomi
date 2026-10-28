import Foundation
import TomiCore

/// Home's progress for previews, from the fake server's returning cook. Nothing is read from the phone or a server.
extension ShownProgress {
    static func previewReturning() -> ShownProgress? {
        preview(.online)
    }

    /// Offline with two cooks on the phone.
    static func previewOffline() -> ShownProgress? {
        preview(ProgressSituation(unsentCooks: 2, isOffline: true))
    }

    /// A new cook offline, before any snapshot arrived.
    static func previewWithoutSnapshot() -> ShownProgress {
        ShownProgress(snapshot: nil, situation: ProgressSituation(unsentCooks: 0, isOffline: true), now: .now)
    }

    private static func preview(_ situation: ProgressSituation) -> ShownProgress? {
        guard let snapshot = try? FakeProgressFixture.returning.snapshot() else {
            return nil
        }
        return ShownProgress(snapshot: snapshot, situation: situation, now: snapshot.computedAt.date)
    }
}
