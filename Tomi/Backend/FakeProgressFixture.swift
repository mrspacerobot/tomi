import Foundation
import TomiCore

/// The progress snapshots the fake server answers with, chosen by launch argument. Each is a fixture file in the
/// app's bundle, read and handed over unchanged: the fake works nothing out, so no game rule comes back into the app.
nonisolated enum FakeProgressFixture: String, Sendable {
    /// A cook with no cooks yet: every number zero, as the server sends it.
    case newCook = "progress-new-cook"
    /// tomi-backend's `docs/examples/progress.json`, copied verbatim.
    case returning = "progress-returning"

    /// The snapshot in the fixture. Throws when the file is missing or cannot be read, never gives zeros instead.
    func snapshot() throws -> ProgressSnapshot {
        guard let url = Bundle.main.url(forResource: rawValue, withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode(ProgressSnapshot.self, from: try Data(contentsOf: url))
    }
}
