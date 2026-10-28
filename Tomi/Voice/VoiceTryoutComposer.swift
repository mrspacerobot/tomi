import SwiftUI

/// The text field with its Speak and Stop buttons. The keyboard opens at once, because the screen exists to type into.
struct VoiceTryoutComposer: View {
    @Bindable var model: VoiceTryoutModel
    @FocusState private var isTyping: Bool

    var body: some View {
        VStack(spacing: Spacing.small) {
            TextField(.voiceTryoutPlaceholder, text: $model.draft)
                .textFieldStyle(.roundedBorder)
                .focused($isTyping)
                .submitLabel(.send)
                .onSubmit(speak)
                .accessibilityIdentifier("voice-tryout-field")
            VoiceTryoutButtons(model: model)
        }
        .onAppear { isTyping = true }
    }

    private func speak() {
        Task { await model.speak() }
        isTyping = true
    }
}

#Preview {
    VoiceTryoutComposer(model: VoiceTryoutModel(speaker: FakeSpeaker()))
        .padding()
}

#Preview("Largest text") {
    VoiceTryoutComposer(model: VoiceTryoutModel(speaker: FakeSpeaker()))
        .padding()
        .dynamicTypeSize(.accessibility5)
}
