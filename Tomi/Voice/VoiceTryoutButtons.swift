import SwiftUI

/// Speak says the typed line. Stop is on only while Tomi is speaking.
struct VoiceTryoutButtons: View {
    let model: VoiceTryoutModel

    var body: some View {
        HStack {
            Button(.voiceTryoutSpeak) {
                Task { await model.speak() }
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("voice-tryout-speak")
            Button(.voiceTryoutStop, action: model.stop)
                .buttonStyle(.bordered)
                .disabled(!model.isSpeaking)
        }
        .frame(minHeight: 44)
    }
}
