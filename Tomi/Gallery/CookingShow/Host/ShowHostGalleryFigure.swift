#if DEBUG
    import SwiftUI

    struct ShowHostGalleryFigure: View {
        let state: CompanionState?

        var body: some View {
            Group {
                if let state {
                    TomiCompanion(state: state, reduceMotion: true, appearance: .cookingShow)
                } else {
                    TomiHostHead().frame(width: MascotSize.showHostPortrait, height: MascotSize.showHostPortrait)
                }
            }
            .frame(width: MascotSize.showHostTile, height: MascotSize.showHostTile)
        }
    }

    #Preview("Morning") { ShowHostGalleryFigure(state: .celebrating).preferredColorScheme(.light) }
    #Preview("Evening, largest text") {
        ShowHostGalleryFigure(state: nil).preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
    }
#endif
