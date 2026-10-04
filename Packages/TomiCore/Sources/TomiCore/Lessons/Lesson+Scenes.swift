extension Lesson {
    /// Scene names in this lesson that this build cannot draw, in step order.
    /// The app shows those steps with the plain drawing. The lessons we ship must have none,
    /// so a mistyped scene is caught by the tests over the shipped files and not by a cook.
    public var unknownSceneNames: [String] {
        var names: [String] = []
        for step in steps {
            if let name = step.unknownSceneName {
                names.append(name)
            }
        }
        return names
    }
}
