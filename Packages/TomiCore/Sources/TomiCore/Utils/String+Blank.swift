extension String {
    /// Empty or only spaces. A hand-typed id or text like that is an easy slip that still decodes.
    var isBlank: Bool {
        allSatisfy(\.isWhitespace)
    }
}
