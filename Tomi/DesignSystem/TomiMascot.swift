import SwiftUI

/// Tomi the tomato chef, drawn in code and scaled to fit.
struct TomiMascot: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let drawing = MascotDrawing(palette: .palette(for: colorScheme))
        Canvas { context, size in
            drawing.draw(in: MascotDrawing.fitted(context, to: size))
        }
        .accessibilityElement()
    }
}

#Preview {
    TomiMascot()
        .frame(width: MascotSize.welcome, height: MascotSize.welcome)
        .padding()
        .background(ColorRole.paper.color)
}
