import SwiftUI

/// Labels graph draft content explicitly as owner testing material.
struct DraftTeachingLabel: View {
    let isDraft: Bool

    var body: some View {
        if isDraft {
            Text(.cookingDraftLabel).textStyle(.showLabel)
        }
    }
}
