import Foundation

@testable import Tomi

/// The invented quiz the UI tests hand the fake server by launch argument. It lives with the UI tests, never in the
/// app, so no right choice ships; unit tests read the same file from the repository.
enum FakeQuizFixture {
    static let file = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appending(path: "TomiUITests/Fixtures/fake-quiz.json")

    static let spoon = "technique/scramble/quiz/fake-spoon"
    static let bell = "technique/scramble/quiz/fake-bell"

    static func text() throws -> String {
        try String(contentsOf: file, encoding: .utf8)
    }

    /// The text as the launch argument carries it.
    static func base64() throws -> String {
        Data(try text().utf8).base64EncodedString()
    }

    static func quiz() throws -> FakeQuiz {
        try FakeQuiz.decode(from: text())
    }
}
