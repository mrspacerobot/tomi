import Foundation

/// A fixture the fake server answers from, read from the app bundle.
nonisolated enum FakeFixtureFile {
    static func data(named name: String) throws -> Data {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try Data(contentsOf: url)
    }
}
