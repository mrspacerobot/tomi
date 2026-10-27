import SwiftUI
import TomiCore

struct HomeSpecialCard: View {
    @Binding var path: [HomeRoute]
    let profile: CookProfile
    let options: LibraryOptions?

    var body: some View {
        DoubleRuledBox(flag: .homeSpecialFlag) {
            HomeSpecialCopy()
            HomeSpecialActions(path: $path)
            HomeCupboardEntry(path: $path, profile: profile, options: options)
        }
    }
}

#Preview {
    HomeSpecialCard(path: .constant([]), profile: CookProfile(), options: nil)
        .padding()
        .background(ColorRole.paper.color)
}
