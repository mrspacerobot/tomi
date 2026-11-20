import SwiftUI
import TomiCore

/// The graph concept and unchanged what and why prose inside Tomi's double-rule box.
struct TeachingConceptBox: View {
    let teaching: Teaching

    var body: some View {
        ShowCard {
            VStack(alignment: .leading, spacing: ShowSize.gap) {
                ShowLowerThird(title: .cookingTheTechnique)
                Text(teaching.introduction.concept).textStyle(.cardTitle)
                Text(teaching.introduction.what).textStyle(.showText)
                Text(teaching.introduction.why).textStyle(.showText, color: .showMuted)
            }
        }
    }
}
