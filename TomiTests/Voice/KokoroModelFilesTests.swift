import Foundation
import Testing

@testable import Tomi

@MainActor
@Suite struct KokoroModelFilesTests {
    let workspace = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
    let layout = KokoroFileLayout(folders: [
        "models/ANE": ["weights.bin", "net.mlmodelc"], "models/root": ["words.json"],
    ])

    func makeResources(named name: String, files: [String]) throws -> URL {
        let folder = workspace.appending(path: name)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        for file in files {
            try Data(file.utf8).write(to: folder.appending(path: file))
        }
        return folder
    }

    @Test func everyFileIsLinkedIntoItsFolder() throws {
        let resources = try makeResources(named: "app", files: ["weights.bin", "net.mlmodelc", "words.json"])
        let target = workspace.appending(path: "target")
        try KokoroModelFiles.link(layout, from: resources, into: target)
        let linked = target.appending(path: "models/ANE/weights.bin")
        #expect(try Data(contentsOf: linked) == Data("weights.bin".utf8))
        #expect(try Data(contentsOf: target.appending(path: "models/root/words.json")) == Data("words.json".utf8))
    }

    @Test func linkingAgainChangesNothing() throws {
        let resources = try makeResources(named: "app", files: ["weights.bin", "net.mlmodelc", "words.json"])
        let target = workspace.appending(path: "target")
        try KokoroModelFiles.link(layout, from: resources, into: target)
        try KokoroModelFiles.link(layout, from: resources, into: target)
        #expect(try Data(contentsOf: target.appending(path: "models/ANE/net.mlmodelc")) == Data("net.mlmodelc".utf8))
    }

    @Test func aLinkToAnOlderInstallIsPointedAtTheCurrentOne() throws {
        let older = try makeResources(named: "older", files: ["weights.bin", "net.mlmodelc", "words.json"])
        let newer = workspace.appending(path: "newer")
        try FileManager.default.copyItem(at: older, to: newer)
        try Data("new".utf8).write(to: newer.appending(path: "words.json"))
        let target = workspace.appending(path: "target")
        try KokoroModelFiles.link(layout, from: older, into: target)
        try KokoroModelFiles.link(layout, from: newer, into: target)
        #expect(try Data(contentsOf: target.appending(path: "models/root/words.json")) == Data("new".utf8))
    }

    @Test func aMissingBundledFileIsReported() throws {
        let resources = try makeResources(named: "app", files: ["weights.bin", "words.json"])
        #expect(throws: SpeakerError.unavailable) {
            try KokoroModelFiles.link(layout, from: resources, into: workspace.appending(path: "target"))
        }
    }

    @Test func theShippedAppCarriesEveryFileOfTheLayout() throws {
        let shipped = try KokoroFileLayout.bundled()
        let resources = try #require(Bundle.main.resourceURL)
        for name in shipped.folders.values.flatMap({ $0 }) {
            #expect(FileManager.default.fileExists(atPath: resources.appending(path: name).path), "\(name)")
        }
    }

    @Test func theVoiceNamedInTheSettingsIsAmongTheBundledFiles() throws {
        let settings = try #require(VoiceSettings.bundled())
        let names = try KokoroFileLayout.bundled().folders.values.flatMap { $0 }
        #expect(names.contains("\(settings.voice).bin"))
    }
}
