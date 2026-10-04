import CoreGraphics
import Testing

@testable import Tomi

/// Chips are set like words: side by side while they fit, then on the next row.
@Suite struct FlowCursorTests {
    static let chip = CGSize(width: 40, height: 44)

    @Test func thingsThatFitStandSideBySide() {
        var cursor = FlowCursor(width: 100, spacing: 8)

        let first = cursor.place(Self.chip)
        let second = cursor.place(Self.chip)

        #expect(first == CGPoint(x: 0, y: 0))
        #expect(second == CGPoint(x: 48, y: 0))
        #expect(cursor.size == CGSize(width: 88, height: 44))
    }

    @Test func aThingThatDoesNotFitStartsTheNextRow() {
        var cursor = FlowCursor(width: 100, spacing: 8)

        _ = cursor.place(Self.chip)
        _ = cursor.place(Self.chip)
        let third = cursor.place(Self.chip)

        #expect(third == CGPoint(x: 0, y: 52))
        #expect(cursor.size == CGSize(width: 88, height: 96))
    }

    @Test func aThingThatEndsExactlyAtTheEdgeStillFits() {
        var cursor = FlowCursor(width: 88, spacing: 8)

        _ = cursor.place(Self.chip)
        let second = cursor.place(Self.chip)

        #expect(second == CGPoint(x: 48, y: 0))
    }

    @Test func aThingWiderThanTheRowIsPlacedAtItsStartAndNotPushedDownForEver() {
        var cursor = FlowCursor(width: 30, spacing: 8)

        let first = cursor.place(Self.chip)
        let second = cursor.place(Self.chip)

        #expect(first == CGPoint(x: 0, y: 0))
        #expect(second == CGPoint(x: 0, y: 52))
    }

    @Test func aRowIsAsTallAsItsTallestThing() {
        var cursor = FlowCursor(width: 100, spacing: 8)

        _ = cursor.place(CGSize(width: 40, height: 60))
        _ = cursor.place(Self.chip)
        let third = cursor.place(Self.chip)

        #expect(third == CGPoint(x: 0, y: 68))
    }
}
