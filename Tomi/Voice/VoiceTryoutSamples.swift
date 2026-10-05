import SwiftUI

/// Lines to tap for a quick listen, for when typing is not at hand.
struct VoiceTryoutSamples: View {
    let model: VoiceTryoutModel
    private let samples: [LocalizedStringResource] = [
        .voiceTryoutSampleHello, .voiceTryoutSampleHeat, .voiceTryoutSamplePraise,
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            ForEach(samples.indices, id: \.self) { index in
                VoiceTryoutSampleButton(model: model, line: samples[index])
                    .accessibilityIdentifier("voice-tryout-sample-\(index)")
            }
        }
    }
}

#Preview {
    VoiceTryoutSamples(model: VoiceTryoutModel(speaker: FakeSpeaker()))
        .padding()
}

#Preview("Largest text") {
    VoiceTryoutSamples(model: VoiceTryoutModel(speaker: FakeSpeaker()))
        .padding()
        .dynamicTypeSize(.accessibility5)
}
