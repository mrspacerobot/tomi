import SwiftUI

/// The lesson player: what to get out, one step at a time, then the question and the finished cook.
struct PlayerView: View {
    @State var model: PlayerModel
    let done: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                PlayerPageView(model: model)
                    .padding(Spacing.stepMargin)
            }
            PlayerFooter(model: model, done: done)
        }
        .background(ColorRole.paper.color)
        .navigationBarBackButtonHidden()
    }
}
