import Foundation
import Testing
import TomiCore

@testable import Tomi

/// How lesson files are found and judged in a bundle: a bad one is skipped, never shown and never a crash.
@Suite struct LessonFileLoadingTests {
    @Test func aValidLessonFileInAnyBundleIsRead() throws {
        let omelette = try LibraryFixture.shippedOmelette()
        let bundle = try LibraryFixture.bundle(lessonFiles: [omelette.fileName: LibraryFixture.file(omelette)])
        #expect(BundledLessonLibrary(bundle: bundle).lessons == [omelette])
    }

    @Test func aLibraryWithoutLessonFilesHasNoLessons() throws {
        let bundle = try LibraryFixture.bundle(lessonFiles: [:])
        #expect(BundledLessonLibrary(bundle: bundle).lessons.isEmpty)
        #expect(BundledLessonLibrary(bundle: bundle).catalog != nil)
    }

    @Test func aFileNotNamedLikeALessonIsNotRead() throws {
        let omelette = try LibraryFixture.shippedOmelette()
        let name = omelette.id.rawValue + ".json"
        let bundle = try LibraryFixture.bundle(lessonFiles: [name: LibraryFixture.file(omelette)])
        #expect(BundledLessonLibrary(bundle: bundle).lessons.isEmpty)
    }

    @Test func aLessonWithAnUnknownIngredientIsSkippedAndTheOthersAreKept() throws {
        let omelette = try LibraryFixture.shippedOmelette()
        var broken = omelette
        broken.id = "dragon-omelette"
        broken.ingredients[0].ingredient = "dragon-fruit"
        let files = [
            omelette.fileName: try LibraryFixture.file(omelette), broken.fileName: try LibraryFixture.file(broken),
        ]
        let bundle = try LibraryFixture.bundle(lessonFiles: files)
        #expect(BundledLessonLibrary(bundle: bundle).lessons == [omelette])
    }

    @Test func aLessonAskingForEquipmentTheListDoesNotKnowIsSkippedAndTheOthersAreKept() throws {
        let omelette = try LibraryFixture.shippedOmelette()
        var broken = omelette
        broken.id = "wok-omelette"
        broken.equipment.insert("wok")
        let files = [
            omelette.fileName: try LibraryFixture.file(omelette), broken.fileName: try LibraryFixture.file(broken),
        ]
        let bundle = try LibraryFixture.bundle(lessonFiles: files)
        #expect(BundledLessonLibrary(bundle: bundle).lessons == [omelette])
    }

    @Test func aLessonWithAnUnknownSceneIsSkipped() throws {
        var broken = try LibraryFixture.shippedOmelette()
        broken.steps[0].sceneName = "juggle"
        let bundle = try LibraryFixture.bundle(lessonFiles: [broken.fileName: LibraryFixture.file(broken)])
        #expect(BundledLessonLibrary(bundle: bundle).lessons.isEmpty)
    }

    @Test(arguments: ["", "not json", #"{"schemaVersion": 99}"#, #"{"schemaVersion": 1}"#])
    func anUnreadableLessonFileIsSkipped(contents: String) throws {
        let bundle = try LibraryFixture.bundle(lessonFiles: ["broken.lesson.json": Data(contents.utf8)])
        #expect(BundledLessonLibrary(bundle: bundle).lessons.isEmpty)
    }

    @Test func aLessonFileNamedAfterAnotherLessonIsSkipped() throws {
        let omelette = try LibraryFixture.shippedOmelette()
        let bundle = try LibraryFixture.bundle(lessonFiles: ["another.lesson.json": LibraryFixture.file(omelette)])
        #expect(BundledLessonLibrary(bundle: bundle).lessons.isEmpty)
    }

    @Test func theFakeLibraryServesWhatItIsGiven() throws {
        let omelette = try LibraryFixture.shippedOmelette()
        let empty: any LessonLibrary = FakeLessonLibrary()
        let stocked: any LessonLibrary = FakeLessonLibrary(catalog: BundledLibrary.catalog(), lessons: [omelette])
        #expect(empty.lessons.isEmpty)
        #expect(empty.ingredientTable == nil)
        #expect(empty.equipmentList == nil)
        #expect(stocked.lessons == [omelette])
        #expect(stocked.catalog == BundledLibrary.catalog())
    }
}
