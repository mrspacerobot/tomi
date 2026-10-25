import SwiftUI

/// The app icon: Tomi at rest, drawn from the same parts as everywhere in the app, on the tinted wash of the
/// welcome screen's disc. A test renders it into the asset catalog (`scripts/render-app-icon.sh`), so the icon
/// cannot drift from the drawing. It fills whatever square it is given.
struct AppIconArtwork: View {
    let appearance: AppIconAppearance

    var body: some View {
        let drawing = AppIconDrawing(figure: CompanionDrawing(pose: CompanionPose(), palette: .tokens))
        ZStack {
            ColorRole.wash.color
            Canvas { context, size in
                drawing.draw(in: context, size: size)
            }
        }
        .grayscale(appearance.grayscale)
        .environment(\.colorScheme, appearance.colorScheme)
    }
}

#Preview {
    HStack {
        ForEach(AppIconAppearance.allCases, id: \.self) { appearance in
            AppIconArtwork(appearance: appearance)
                .frame(width: MascotSize.notice, height: MascotSize.notice)
                .clipShape(.rect(cornerRadius: Radius.sheet))
        }
    }
    .padding()
}
