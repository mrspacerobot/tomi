import SwiftUI

/// A repeat of the three painted folds in the show's curtains.
struct ShowCurtainFabric: View {
    var body: some View {
        Canvas { context, size in
            let foldWidth = ShowStageSize.fold
            let count = Int(ceil(size.width / foldWidth))
            for index in 0..<count {
                drawFold(index, height: size.height, in: context)
            }
        }
        .accessibilityHidden(true)
    }

    private func drawFold(_ index: Int, height: CGFloat, in context: GraphicsContext) {
        let fold = ShowStageSize.fold
        let stripe = ShowStageSize.stripe
        let left = CGFloat(index) * fold
        let base = CGRect(x: left, y: 0, width: fold, height: height)
        let lit = CGRect(x: left + stripe, y: 0, width: stripe, height: height)
        let shade = CGRect(x: left + 2 * stripe, y: 0, width: fold - 2 * stripe, height: height)
        context.fill(Path(base), with: .color(ColorRole.curtainRed.color))
        context.fill(Path(lit), with: .color(ColorRole.curtainLight.color))
        context.fill(Path(shade), with: .color(ColorRole.curtainShade.color))
    }
}

#Preview("Morning") { ShowCurtainFabric().preferredColorScheme(.light) }
#Preview("Evening") { ShowCurtainFabric().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5) }
