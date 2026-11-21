import SwiftUI
import TomiCore

struct HomeMastheadWords: View {
    let date: Date

    var body: some View {
        VStack(spacing: Spacing.xxSmall) {
            TomiHostHead().frame(width: MascotSize.home, height: MascotSize.home)
            HomeMastheadHeading(date: date)
        }
    }
}

#Preview {
    HomeMasthead(date: .now)
        .padding()
        .background { ShowStage() }
}
