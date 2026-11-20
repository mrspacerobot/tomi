import SwiftUI

struct ShowMarqueeBulbs: View {
    var body: some View {
        Canvas { context, size in
            let color = ColorRole.showBulb.color
            for center in centers(in: size) {
                let bulb = Path(ellipseIn: bulbFrame(at: center))
                context.fill(bulb, with: .color(color))
            }
        }
        .accessibilityHidden(true)
    }

    private func centers(in size: CGSize) -> [CGPoint] {
        let inset = ShowSize.marqueeBorder / 2
        let horizontal = positions(along: size.width).flatMap {
            [CGPoint(x: $0, y: inset), CGPoint(x: $0, y: size.height - inset)]
        }
        let vertical = positions(along: size.height).flatMap {
            [CGPoint(x: inset, y: $0), CGPoint(x: size.width - inset, y: $0)]
        }
        return horizontal + vertical
    }

    private func positions(along length: CGFloat) -> [CGFloat] {
        let count = max(0, Int(length / ShowSize.bulbSpacing) - 1)
        let offset = (length - CGFloat(count) * ShowSize.bulbSpacing) / 2
        return (0...count).map { offset + CGFloat($0) * ShowSize.bulbSpacing }
    }

    private func bulbFrame(at center: CGPoint) -> CGRect {
        let diameter = ShowSize.bulbDiameter
        return CGRect(x: center.x - diameter / 2, y: center.y - diameter / 2, width: diameter, height: diameter)
    }
}

#Preview("Morning") { ShowMarquee(title: .showGalleryTitle).preferredColorScheme(.light) }
#Preview("Evening, largest text") {
    ShowMarquee(title: .showGalleryTitle).preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
