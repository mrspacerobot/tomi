import XCTest

extension XCUIApplication {
    /// The fake server and sign-in, for a cook who has signed in and answered the first questions before.
    static let returningCook = ["--fake-backend", "--fake-signed-in"]
    /// The fake server and sign-in, for a cook who opens Tomi for the first time.
    static let newCook = ["--fake-backend", "--store-in-memory"]

    /// A returning cook whose fake server has no suggestion tonight.
    static let noSuggestionsCook = returningCook + ["--store-in-memory", "--fake-no-suggestions"]

    @MainActor static func launched(_ arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()
        return app
    }
}
