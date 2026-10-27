import SwiftUI
import TomiCore

struct HomeSpecialCopy: View {
    var body: some View {
        VStack(spacing: Spacing.xxSmall) {
            HomeBlankDishLine()
            Text(.homeSpecialTitle).textStyle(.title)
            Text(.homeSpecialPrompt).textStyle(.description)
        }
    }
}

#Preview {
    HomeSpecialCard(path: .constant([]), profile: CookProfile(), options: nil)
        .padding()
        .background(ColorRole.paper.color)
}
