import SwiftUI

/// A screen for hearing Tomi's voice: type a line, tap Speak, tap a line again to hear it again.
/// For developer builds only, until the lesson player speaks the steps.
struct VoiceTryoutView: View {
    @State private var model: VoiceTryoutModel

    init(speaker: any Speaker) {
        _model = State(initialValue: VoiceTryoutModel(speaker: speaker))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.medium) {
                VoiceTryoutSamples(model: model)
                VoiceTryoutLines(model: model)
                if model.didFail {
                    Text(.voiceTryoutFailed).textStyle(.body)
                }
            }
            .padding(Spacing.xLarge)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            VoiceTryoutComposer(model: model)
                .padding(Spacing.xLarge)
                .background(ColorRole.paper.color)
        }
        .background(ColorRole.paper.color)
    }
}

#Preview {
    VoiceTryoutView(speaker: FakeSpeaker())
}
