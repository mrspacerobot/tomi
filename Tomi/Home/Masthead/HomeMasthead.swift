import SwiftUI
import TomiCore

struct HomeMasthead: View {
    @Binding var path: [HomeRoute]
    let date: Date

    var body: some View {
        HomeMastheadWords(date: date)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topTrailing) {
                HomeSettingsEntry(path: $path)
            }
    }
}

#Preview {
    HomeMasthead(path: .constant([]), date: .now)
        .padding()
        .background(ColorRole.paper.color)
}
