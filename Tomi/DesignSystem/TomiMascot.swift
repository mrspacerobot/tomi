import SwiftUI

/// Tomi the tomato chef, drawn in code and scaled to fit.
struct TomiMascot: View {
    var body: some View {
        Canvas { context, size in
            MascotDrawing.draw(in: MascotDrawing.fitted(context, to: size))
        }
        .accessibilityElement()
    }
}

#Preview {
    TomiMascot()
        .frame(width: 240, height: 240)
        .padding()
        .background(Theme.paper)
}
