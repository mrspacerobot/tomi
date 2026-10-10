import SwiftUI
import TomiCore

/// Opens the lesson an offer names, at its revision, from the phone's library, with the offer's swaps applied.
/// A lesson the phone does not have, or a swap it does not list, is never cooked from a guess.
struct PlayerLauncher: View {
    let offer: Offer
    let flow: AppFlowModel
    let done: () -> Void

    var body: some View {
        if let dish {
            PlayerView(model: PlayerModel(dish: dish, offer: offer, flow: flow), done: done)
        } else {
            LessonMissingView(done: done)
        }
    }

    private var dish: Lesson? {
        guard let written = flow.services.library.lesson(offer.lessonID, revision: offer.revision) else {
            return nil
        }
        return try? written.applying(listed: offer.swaps.map(\.applied))
    }
}
