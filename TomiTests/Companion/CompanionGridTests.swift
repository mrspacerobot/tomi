import CoreGraphics
import Testing

@testable import Tomi

/// The drawing grid fits any frame without being cut off or stretched.
struct CompanionGridTests {
    @Test func aSquareFrameIsLimitedByTheGridHeight() {
        let fit = CompanionGrid.fit(in: CGSize(width: 270, height: 270))
        #expect(fit.scale == 1)
        #expect(fit.origin.x == 15)
        #expect(fit.origin.y == 0)
    }

    @Test func aWideFrameCentresTheFigure() {
        let fit = CompanionGrid.fit(in: CGSize(width: 1000, height: 135))
        #expect(fit.scale == 0.5)
        #expect(fit.origin.x == (1000 - CompanionGrid.size.width / 2) / 2)
    }
}
