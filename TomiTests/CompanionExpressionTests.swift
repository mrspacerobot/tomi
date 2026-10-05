import Testing

@testable import Tomi

struct CompanionExpressionTests {
    @Test @MainActor func celebratingHasACurvedSmile() throws {
        let rig = CompanionRig()
        rig.configure(CompanionPresentation(state: .celebrating, moving: false))
        #expect(rig.face.mouth.children.count > 2)
        let corner = try #require(rig.face.mouth.children.first)
        let middle = try #require(rig.face.mouth.children.dropFirst(6).first)
        #expect(corner.position.y > middle.position.y)
    }

    @Test @MainActor func celebratingLiftsTheBrowsAtTheMiddle() {
        let rig = CompanionRig()
        rig.configure(CompanionPresentation(state: .celebrating, moving: false))
        #expect(rig.face.leftBrow.orientation.act(SIMD3<Float>(1, 0, 0)).y > 0)
        #expect(rig.face.rightBrow.orientation.act(SIMD3<Float>(-1, 0, 0)).y > 0)
    }
}
