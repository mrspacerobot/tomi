import SwiftUI

/// One sample line. The text wraps, so it stays whole at the largest text size.
struct VoiceTryoutSampleButton: View {
    let model: VoiceTryoutModel
    let line: LocalizedStringResource

    var body: some View {
        Button {
            Task { await model.say(String(localized: line)) }
        } label: {
            Text(line)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.roundedRectangle)
    }
}

#Preview {
    VoiceTryoutSampleButton(model: VoiceTryoutModel(speaker: FakeSpeaker()), line: .voiceTryoutSampleHeat)
        .padding()
}

#Preview("Largest text") {
    VoiceTryoutSampleButton(model: VoiceTryoutModel(speaker: FakeSpeaker()), line: .voiceTryoutSampleHeat)
        .padding()
        .dynamicTypeSize(.accessibility5)
}
