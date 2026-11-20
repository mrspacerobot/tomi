import SwiftUI
import TomiCore

struct HomeSpecialCopy: View {
    var body: some View {
        VStack(alignment: .leading, spacing: ShowSize.gap) {
            ShowLowerThird(title: .guideOnAir)
            Text(.homeSpecialTitle).textStyle(.cardTitle)
            Text(.homeSpecialPrompt).textStyle(.showNote)
        }
    }
}

#Preview {
    HomeSpecialCard(path: .constant([]), profile: CookProfile(), options: nil)
        .padding()
        .background { ShowStage() }
}
