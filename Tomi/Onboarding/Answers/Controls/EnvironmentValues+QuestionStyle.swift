import SwiftUI

extension EnvironmentValues {
    /// Shared question editors keep their current appearance in Settings until that screen migrates.
    @Entry var usesShowQuestionStyle = false
}
