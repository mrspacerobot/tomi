import Foundation

/// The checked-in list of coverage gaps (`docs/lesson-coverage-gaps.txt`): the honest to-do list of the library.
enum KnownCoverageGaps {
    static let path = "docs/lesson-coverage-gaps.txt"

    static let header = [
        "# Lesson coverage gaps: the levels that have no lesson for some cooks.",
        "# One line per level: \"<skill> <level>: <diets with no lesson>\". \"any\" is a cook who keeps no diet.",
        "# Checked by LessonCoverageTests, so this list can only shrink. After adding lessons, rewrite it with:",
        "#   TOMI_UPDATE_COVERAGE=1 swift test --package-path Packages/TomiCore",
    ]

    /// The gap lines of the file, without the header and blank lines.
    static func lines() throws -> [String] {
        let text = try Repository.text(path)
        var lines: [String] = []
        for line in text.split(separator: "\n") where !line.hasPrefix("#") {
            lines.append(String(line))
        }
        return lines
    }

    static func write(_ gapLines: [String]) throws {
        let text = (header + gapLines).joined(separator: "\n") + "\n"
        try text.write(to: Repository.file(path), atomically: true, encoding: .utf8)
    }

    /// Set by the person who has just added lessons and wants the list rewritten from the library.
    static var shouldRewrite: Bool {
        ProcessInfo.processInfo.environment["TOMI_UPDATE_COVERAGE"] == "1"
    }
}
