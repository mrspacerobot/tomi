import Foundation

/// The invented quiz with its right choices, handed to the fake server by launch argument in base64. It lives
/// here with the UI tests (`Fixtures/fake-quiz.json`, copied into the UI test bundle) and never in the app, so no
/// right choice ships.
final class FakeQuizLaunch {
    /// The arguments that make tonight's guided suggestion ask the invented quiz.
    static var arguments: [String] {
        guard let file = Bundle(for: FakeQuizLaunch.self).url(forResource: "fake-quiz", withExtension: "json"),
            let data = try? Data(contentsOf: file)
        else {
            return []
        }
        return ["--fake-quiz", data.base64EncodedString()]
    }

    static var offline: [String] {
        arguments + ["--fake-quiz-offline"]
    }
}
