import SwiftUI
import TomiCore

struct HomeBlankDishLine: View {
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Spacing.xSmall) {
            Text(.homeBlankDish).textStyle(.description)
            DottedLeader()
        }
        .padding(.horizontal, Spacing.xxSmall)
    }
}

#Preview {
    HomeSpecialCard(path: .constant([]), profile: CookProfile(), options: nil)
        .padding()
        .background(ColorRole.paper.color)
}
