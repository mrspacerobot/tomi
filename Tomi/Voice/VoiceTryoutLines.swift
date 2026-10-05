import SwiftUI

/// The lines already said. Tapping one says it again.
struct VoiceTryoutLines: View {
    let model: VoiceTryoutModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
