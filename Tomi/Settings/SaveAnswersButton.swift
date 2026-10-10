import SwiftUI

/// Saves the answers of a settings question.
struct SaveAnswersButton: View {
    let saver: AnswersSaver
    let save: () -> Void

    var body: some View {
        Button(action: save) { Text(.settingsSave) }
            .buttonStyle(.tomiPrimary)
            .disabled(saver.isSaving)
            .accessibilityIdentifier("settings-save")
    }
}
