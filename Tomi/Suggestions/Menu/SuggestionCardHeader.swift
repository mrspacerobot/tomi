import SwiftUI
import TomiCore

struct SuggestionCardHeader: View {
    let suggestion: Suggestion
    let flag: LocalizedStringResource?
    let photo: CGImage?

    var body: some View {
        if let photo { SuggestionPhoto(photo: photo) }
        if let flag { ShowLowerThird(title: flag) }
        SuggestionHeading(suggestion: suggestion, isSpecial: flag != nil)
    }
}
