import Foundation

/// The fake server's snapshot fixtures as text, read from the app's bundle where the fake reads them.
enum ProgressFixtureText {
    static var returning: String {
        text(of: "progress-returning")
    }

    static var newCook: String {
        text(of: "progress-new-cook")
    }

    private static func text(of name: String) -> String {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            return "{}"
        }
        return (try? String(contentsOf: url, encoding: .utf8)) ?? "{}"
    }
}
