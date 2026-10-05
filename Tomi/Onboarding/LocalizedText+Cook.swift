import Foundation
import TomiCore

extension LocalizedText {
    /// The words in the cook's own language, falling back to English.
    var forCook: String {
        resolved(preferredLanguages: Locale.preferredLanguages)
    }
}
