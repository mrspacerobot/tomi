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
            VStack(alignment: .leading, spacing: 16) {
                VoiceTryoutSamples(model: model)
                VoiceTryoutLines(model: model)
                if model.didFail {
                    Text(.voiceTryoutFailed).textStyle(.subtitle)
                }
            }
            .padding(24)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            VoiceTryoutComposer(model: model)
                .padding(24)
                .background(Theme.paper)
        }
        .background(Theme.paper)
    }
}

#Preview {
    VoiceTryoutView(speaker: FakeSpeaker())
}
