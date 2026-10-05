import SwiftUI

/// Speak says the typed line. Stop is on only while Tomi is speaking.
/// The large control size makes each button itself at least 44 points tall, so the whole button can be tapped.
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
        .controlSize(.large)
    }
}

#Preview {
    VoiceTryoutButtons(model: VoiceTryoutModel(speaker: FakeSpeaker()))
        .padding()
}

#Preview("Largest text") {
    VoiceTryoutButtons(model: VoiceTryoutModel(speaker: FakeSpeaker()))
        .padding()
        .dynamicTypeSize(.accessibility5)
}
