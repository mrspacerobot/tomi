/// Why a lesson in progress cannot be picked up again. The cook then starts from tonight's special instead.
public enum ResumeError: Error, Equatable {
    /// The library no longer has the lesson at the revision the cook started.
    case lessonNotInLibrary(LessonID)
    /// The lesson does not list a swap the bookmark names.
    case swapNotInLesson(AppliedSwap)
    /// The bookmark points past the last step, or before the first.
    case stepNotInLesson(Int)
}
