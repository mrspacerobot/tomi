import SwiftUI
import TomiCore

/// The graph concept and unchanged what and why prose inside Tomi's double-rule box.
struct TeachingConceptBox: View {
    let teaching: Teaching

    var body: some View {
        DoubleRuledBox(flag: .cookingTheTechnique) {
            Text(teaching.introduction.concept).textStyle(.dish)
            Text(teaching.introduction.what).textStyle(.body)
            Text(teaching.introduction.why).textStyle(.body)
        }
    }
}
