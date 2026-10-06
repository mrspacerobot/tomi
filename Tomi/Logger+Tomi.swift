import Foundation
import OSLog

/// The parts of the app that log, so a category is never typed twice and never misspelled.
enum LogCategory: String {
    case companion
    case library
    case persistence
    case preview
    case progress
    case voice
}

extension Logger {
    /// The one place that names the logging subsystem. It is the app's bundle identifier, which is set once in
    /// the project's build settings, so renaming the app never means searching the code.
    nonisolated init(category: LogCategory) {
        let subsystem = Bundle.main.bundleIdentifier ?? ProcessInfo.processInfo.processName
        self.init(subsystem: subsystem, category: category.rawValue)
    }
}
