import Testing

@testable import TomiCore

/// A scene or a main is drawn in the design kit first. Code may not have one the kit lacks, or lack one it draws.
@Suite struct DesignKitTests {
    @Test func theScenesInCodeAreExactlyTheOnesTheKitDraws() throws {
        let drawn = try DesignKit.sceneNames()
        #expect(drawn.count >= 20)
        #expect(StepScene.allCases.map(\.rawValue) == drawn)
    }

    @Test func theMainsInCodeAreExactlyTheOnesTheKitDraws() throws {
        let drawn = try DesignKit.mainNames()
        #expect(drawn.count >= 3)
        #expect(DishMain.allCases.map(\.rawValue) == drawn)
    }
}
