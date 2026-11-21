import SwiftUI
import TomiCore

struct HomeSpecialCard: View {
    @Binding var path: [HomeRoute]
    let profile: CookProfile
    let options: LibraryOptions?

    var body: some View {
        ShowCard {
            VStack(alignment: .leading, spacing: ShowSize.gap) {
                HomeSpecialCopy()
                HomeSpecialActions(path: $path)
                HomeCupboardEntry(path: $path, profile: profile, options: options)
            }
        }
    }
}

#Preview {
    HomeSpecialCard(path: .constant([]), profile: CookProfile(), options: nil)
        .padding()
        .background { ShowStage() }
}
