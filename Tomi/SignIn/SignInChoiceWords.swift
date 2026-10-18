import SwiftUI

/// A small separator that introduces Apple as another sign-in method.
struct SignInChoiceWords: View {
    var body: some View {
        Text(.authOrApple)
            .textStyle(.label)
            .foregroundStyle(ColorRole.inkFaded.color)
            .textCase(.uppercase)
    }
}

#Preview {
    SignInChoiceWords()
        .padding()
        .background(ColorRole.paper.color)
}
