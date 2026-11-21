import SwiftUI

nonisolated struct ShowSpotlight: Shape {
    func path(in rect: CGRect) -> Path {
        var beam = Path()
        let aperture = rect.width * 0.06
        beam.move(to: CGPoint(x: rect.midX - aperture, y: rect.minY))
        beam.addLine(to: CGPoint(x: rect.midX + aperture, y: rect.minY))
        beam.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        beam.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        beam.closeSubpath()
        return beam
    }
}
