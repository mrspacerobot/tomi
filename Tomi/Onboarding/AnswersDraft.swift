import Foundation
import TomiCore

/// The cook's answers while a question is on screen, before they are sent to the server.
@Observable
final class AnswersDraft {
    var answers: CookProfile
    let options: LibraryOptions
    /// What was avoided when the question opened. Rows for ids the server cannot name come from this, so a row
    /// the cook unticks stays on screen until they save.
    let startingAvoid: Set<OptionID>
    /// The server, for the questions where the cook types a word that it must understand.
    let api: any TomiAPI

    init(answers: CookProfile, options: LibraryOptions, api: any TomiAPI) {
        self.answers = answers
        self.options = options
        startingAvoid = answers.avoid
        self.api = api
    }
}
