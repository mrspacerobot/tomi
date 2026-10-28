import SwiftUI

/// Speak says the typed line. Stop is on only while Tomi is speaking.
/// The large control size makes each button itself at least 44 points tall, so the whole button can be tapped.
struct VoiceTryoutButtons: View {
    let model: VoiceTryoutModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        layout {
            Button(.voiceTryoutSpeak) {
                Task { await model.speak() }
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("voice-tryout-speak")
            Button(.voiceTryoutStop, action: model.stop)
                .buttonStyle(.bordered)
                .disabled(!model.isSpeaking)
                .accessibilityIdentifier("voice-tryout-stop")
        }
        .controlSize(.large)
    }

    /// Side by side normally; stacked once the text is so large that two buttons no longer fit in a row.
    private var layout: AnyLayout {
        if dynamicTypeSize.isAccessibilitySize {
            return AnyLayout(VStackLayout(spacing: Spacing.medium))
        }
        return AnyLayout(HStackLayout(spacing: Spacing.medium))
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
