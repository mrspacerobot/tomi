import Foundation
import TomiCore

/// The cook's answers while a question is on screen, before they are sent to the server.
@Observable
final class AnswersDraft {
    var answers: CookProfile
    let options: LibraryOptions

    init(answers: CookProfile, options: LibraryOptions) {
        self.answers = answers
        self.options = options
    }
}
