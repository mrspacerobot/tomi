import XCTest

extension XCUIApplication {
    /// The fake server and sign-in, for a cook who has signed in and answered the first questions before.
    static let returningCook = ["--fake-backend", "--fake-signed-in"]
    /// The fake server and sign-in, for a cook who opens Tomi for the first time.
    static let newCook = ["--fake-backend", "--store-in-memory"]

    @MainActor static func launched(_ arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()
        return app
    }
}
