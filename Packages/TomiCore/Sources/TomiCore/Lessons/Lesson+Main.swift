extension Lesson {
    /// The food its scenes draw, or nil when the file names one this build does not know.
    public var main: DishMain? {
        DishMain(rawValue: mainName)
    }
}
