import Testing

@testable import TomiCore

/// A scene is decoration: a file may leave it out, or name one from a newer library, and still load.
@Suite struct LessonSceneDecodingTests {
    @Test func aSceneFromANewerLibraryStillLoadsAndIsDrawnPlain() throws {
        let juggle = #"{"text": {"en": "Juggle."}, "scene": "juggle"}"#
        let lesson = try LessonFile.decode(LessonFile.text(step: juggle))
        #expect(lesson.steps[0].scene == nil)
        #expect(lesson.unknownSceneNames == ["juggle"])
    }

    @Test func aStepMayNameNoScene() throws {
        let lesson = try LessonFile.decode(LessonFile.text(step: #"{"text": {"en": "Wait."}}"#))
        #expect(lesson.steps[0].scene == nil)
        #expect(lesson.unknownSceneNames.isEmpty)
    }
}
