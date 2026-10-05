import SwiftUI

/// The lines already said. Tapping one says it again.
struct VoiceTryoutLines: View {
    let model: VoiceTryoutModel

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            ForEach(model.said.reversed(), id: \.self) { line in
                Button {
                    Task { await model.say(line) }
                } label: {
                    Text(verbatim: line).textStyle(.title)
                }
                .accessibilityHint(Text(.voiceTryoutAgainHint))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VoiceTryoutLines(model: VoiceTryoutModel(speaker: FakeSpeaker(), said: ["Heat the pan.", "Well done."]))
        .padding()
}

#Preview("Largest text") {
    VoiceTryoutLines(model: VoiceTryoutModel(speaker: FakeSpeaker(), said: ["Heat the pan.", "Well done."]))
        .padding()
        .dynamicTypeSize(.accessibility5)
}
