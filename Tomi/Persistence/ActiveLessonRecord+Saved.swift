import TomiCore

/// Copies the stored fields to and from the plain value TomiCore reads. No rule lives here.
extension ActiveLessonRecord {
    var saved: SavedActiveLesson {
        var saved = SavedActiveLesson()
        saved.stableID = stableID
        saved.updatedAt = updatedAt
        saved.lesson = lesson
        saved.lessonRevision = lessonRevision
        saved.swappedOut = swappedOut
        saved.swappedIn = swappedIn
        saved.ingredients = ingredients
        saved.currentStep = currentStep
        return saved
    }

    /// Takes the whole bookmark. The id and the time belong to the store and are left as they are.
    func write(_ saved: SavedActiveLesson) {
        lesson = saved.lesson
        lessonRevision = saved.lessonRevision
        swappedOut = saved.swappedOut
        swappedIn = saved.swappedIn
        ingredients = saved.ingredients
        currentStep = saved.currentStep
    }
}
