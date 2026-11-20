import SwiftUI

struct HomeMasthead: View {
    let date: Date

    var body: some View {
        HomeMastheadWords(date: date)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeMasthead(date: .now).padding().background { ShowStage() }
}
