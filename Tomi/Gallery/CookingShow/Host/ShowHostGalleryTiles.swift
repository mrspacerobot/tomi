#if DEBUG
    import SwiftUI

    struct ShowHostGalleryTiles: View {
        @Environment(\.dynamicTypeSize) private var typeSize

        private var columns: [GridItem] {
            let column = GridItem(.flexible())
            if typeSize.isAccessibilitySize { return [column] }
            return [column, column]
        }

        var body: some View {
            LazyVGrid(columns: columns, spacing: ShowSize.rowGap) {
                ForEach(CompanionState.allCases, id: \.self) { state in
                    ShowHostGalleryTile(state: state)
                }
                ShowHostGalleryTile()
            }
        }
    }

    #Preview("Morning") { ShowHostGalleryTiles().preferredColorScheme(.light) }
    #Preview("Evening, largest text") {
        ShowHostGalleryTiles().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
    }
#endif
