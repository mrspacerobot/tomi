import FluidAudio
import Foundation

/// Puts the model files that ship in the app where the voice engine looks for them, so it never has to download.
/// The files are linked and not copied, so they do not take space twice.
enum KokoroModelFiles {
    /// Links the shipped files into the engine's model directory. Does nothing for a link that is already right.
    static func installBundled(in bundle: Bundle = .main) throws {
        guard let resources = bundle.resourceURL else {
            throw SpeakerError.unavailable
        }
        let models = try TtsCacheDirectory.ensure().appending(path: "Models")
        try link(KokoroFileLayout.bundled(in: bundle), from: resources, into: models)
    }

    static func link(_ layout: KokoroFileLayout, from resources: URL, into models: URL) throws {
        for (folder, names) in layout.folders {
            let directory = models.appending(path: folder)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            for name in names {
                try link(resources.appending(path: name), at: directory.appending(path: name))
            }
        }
    }

    /// An app update gives the app a new location, so a link to the old one is replaced.
    private static func link(_ source: URL, at destination: URL) throws {
        let manager = FileManager.default
        guard manager.fileExists(atPath: source.path) else {
            throw SpeakerError.unavailable
        }
        if try isLink(at: destination, to: source) {
            return
        }
        try? manager.removeItem(at: destination)
        try manager.createSymbolicLink(at: destination, withDestinationURL: source)
    }

    private static func isLink(at destination: URL, to source: URL) throws -> Bool {
        guard let target = try? FileManager.default.destinationOfSymbolicLink(atPath: destination.path) else {
            return false
        }
        return target == source.path
    }
}
