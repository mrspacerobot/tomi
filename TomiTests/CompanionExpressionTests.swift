import RealityKit
import Testing

@testable import Tomi

struct CompanionExpressionTests {
    @Test @MainActor func thinkingLiftsTheInnerBrowsRatherThanFurrowingThem() {
        let rig = CompanionRig()
        rig.configure(CompanionPresentation(state: .thinking, moving: false))
        #expect(rig.face.leftBrow.orientation.act(SIMD3<Float>(1, 0, 0)).y > 0)
        #expect(rig.face.rightBrow.orientation.act(SIMD3<Float>(-1, 0, 0)).y > 0)
    }

    @Test @MainActor func thinkingKeepsAQuietVisibleSmile() {
        let rig = CompanionRig()
        rig.configure(CompanionPresentation(state: .thinking, moving: false))
        #expect(rig.face.mouth.scale.y >= CompanionState.idle.pose.mouth * 0.75)
        #expect(rig.face.mouth.scale.y < CompanionState.celebrating.pose.mouth * 0.5)
    }

    @Test @MainActor func celebratingHasACurvedSmile() throws {
        let rig = CompanionRig()
        rig.configure(CompanionPresentation(state: .celebrating, moving: false))
        let mouth = try #require(rig.face.mouth as? ModelEntity)
        let model = try #require(mouth.model?.mesh.contents.models.first)
        let part = try #require(model.parts.first)
        let points = Array(part.positions)
        #expect(points.allSatisfy { $0.z == 0 })
        #expect(points.first!.y > points[13].y)
    }

    @Test @MainActor func celebratingLiftsTheBrowsAtTheMiddle() {
        let rig = CompanionRig()
        rig.configure(CompanionPresentation(state: .celebrating, moving: false))
        #expect(rig.face.leftBrow.orientation.act(SIMD3<Float>(1, 0, 0)).y > 0)
        #expect(rig.face.rightBrow.orientation.act(SIMD3<Float>(-1, 0, 0)).y > 0)
    }
}
