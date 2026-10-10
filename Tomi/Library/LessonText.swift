import Foundation
import TomiCore

/// Content words from the library, in the cook's languages. Screen words come from the string catalog instead.
nonisolated enum LessonText {
    static func resolved(_ text: LocalizedText) -> String {
        text.resolved(preferredLanguages: Locale.preferredLanguages)
    }
}
