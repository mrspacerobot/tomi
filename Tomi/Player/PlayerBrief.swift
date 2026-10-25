import TomiCore

/// What the lesson player needs to know about the lesson it opens: which one, at which revision, under what
/// title, with which swaps applied and how the ingredients are named. Graph recipes have no lesson file, so
/// nothing opens the player with one yet (#135).
struct PlayerBrief: Hashable {
    let lessonID: LessonID
    let revision: Int
    let title: String
    let swaps: [AppliedSwap]
    let ingredients: [NamedOption]
}
