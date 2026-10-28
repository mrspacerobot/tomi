import Foundation

/// Which bundled file belongs in which folder. The app bundle holds every file side by side, but the
/// voice engine looks for them in two folders, so the layout is data that says where each one goes.
nonisolated struct KokoroFileLayout: Decodable, Equatable {
    /// Folder path under the engine's model directory, with the names of the files that belong in it.
    let folders: [String: [String]]

    static func bundled(in bundle: Bundle = .main) throws -> KokoroFileLayout {
        guard let url = bundle.url(forResource: "kokoro-files", withExtension: "json") else {
            throw SpeakerError.unavailable
        }
        return try JSONDecoder().decode(KokoroFileLayout.self, from: Data(contentsOf: url))
    }
}
