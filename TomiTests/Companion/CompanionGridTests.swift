import CoreGraphics
import Testing

@testable import Tomi

/// Tomi fills the frame a screen gives him, and his grid fits any canvas without being stretched.
struct CompanionGridTests {
    @Test func theFigureBoxFillsTheFrameAndTheGridSpillsPastIt() {
        let frame = CGSize(width: 180, height: 212)
        let canvas = CompanionGrid.canvas(in: frame)
        #expect(canvas.size == CompanionGrid.size)
        #expect(canvas.minX == -CompanionGrid.figureBox.minX)
        #expect(canvas.minY == -CompanionGrid.figureBox.minY)
    }

    @Test func aSquareFrameIsLimitedByTheFigureHeightAndCentred() {
        let frame = CGSize(width: 212, height: 212)
        let canvas = CompanionGrid.canvas(in: frame)
        let box = CompanionGrid.figureBox
        let boxLeft = canvas.minX + box.minX
        #expect(boxLeft == (212 - box.width) / 2)
        #expect(canvas.minY + box.minY == 0)
    }

    @Test func aSquareCanvasIsLimitedByTheGridHeight() {
        let fit = CompanionGrid.fit(in: CGSize(width: 270, height: 270))
        #expect(fit.scale == 1)
        #expect(fit.origin.x == 15)
        #expect(fit.origin.y == 0)
    }

    @Test func aWideCanvasCentresTheGrid() {
        let fit = CompanionGrid.fit(in: CGSize(width: 1000, height: 135))
        #expect(fit.scale == 0.5)
        #expect(fit.origin.x == (1000 - CompanionGrid.size.width / 2) / 2)
    }
}
