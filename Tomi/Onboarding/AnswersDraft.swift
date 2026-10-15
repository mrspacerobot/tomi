import Foundation
import TomiCore

/// The cook's answers while a question is on screen, before they are sent to the server.
@Observable
final class AnswersDraft {
    var answers: CookProfile
    let options: LibraryOptions
    /// The server, for the questions where the cook types a word that it must understand.
    let api: any TomiAPI

    init(answers: CookProfile, options: LibraryOptions, api: any TomiAPI) {
        self.answers = answers
        self.options = options
        self.api = api
    }
}
