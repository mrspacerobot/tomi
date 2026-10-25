import SwiftUI
import TomiCore

/// Opens the lesson a brief names, at its revision, from the phone's library, with the brief's swaps applied.
/// A lesson the phone does not have, or a swap it does not list, is never cooked from a guess.
struct PlayerLauncher: View {
    let brief: PlayerBrief
    let flow: AppFlowModel
    let done: () -> Void

    var body: some View {
        if let dish {
            PlayerView(model: PlayerModel(dish: dish, brief: brief, flow: flow), done: done)
        } else {
            LessonMissingView(done: done)
        }
    }

    private var dish: Lesson? {
        guard let written = flow.services.library.lesson(brief.lessonID, revision: brief.revision) else {
            return nil
        }
        return try? written.applying(listed: brief.swaps)
    }
}
