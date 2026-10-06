import Testing

@testable import TomiCore

/// A lesson may only ask for equipment the library lists. A mistyped id would ask for something no kitchen has,
/// and the lesson would never be shown without anyone being told.
@Suite struct LessonEquipmentValidationTests {
    @Test func equipmentMissingFromTheListIsReported() {
        var lesson = Lesson.fixture()
        lesson.equipment = ["stovetop", "stovtop"]
        #expect(lesson.issuesInTheFixtureLibrary() == [.unknownEquipment("stovtop")])
    }

    @Test func everyUnknownPieceIsReportedInAStableOrder() {
        var lesson = Lesson.fixture()
        lesson.equipment = ["wok", "oven", "air-fryer", ""]
        let expected: [LessonIssue] = [.unknownEquipment(""), .unknownEquipment("air-fryer"), .unknownEquipment("wok")]
        #expect(lesson.issuesInTheFixtureLibrary() == expected)
    }

    @Test func equipmentAKitchenIsNotAssumedToHaveIsStillKnown() {
        var lesson = Lesson.fixture()
        lesson.equipment = ["blender"]
        #expect(lesson.issuesInTheFixtureLibrary().isEmpty)
    }

    @Test func aLessonMayNeedNoEquipment() {
        var lesson = Lesson.fixture()
        lesson.equipment = []
        #expect(lesson.issuesInTheFixtureLibrary().isEmpty)
    }

    @Test func aFileWithUnknownEquipmentIsRejectedWithTheLessonID() {
        let file = LessonFile.text().replacing(#""equipment": ["stovetop"]"#, with: #""equipment": ["stovtop"]"#)
        #expect(throws: LessonError.invalid("garlic-butter", [.unknownEquipment("stovtop")])) {
            try LessonFile.decode(file)
        }
    }

    @Test func theSameLessonIsJudgedByTheListItIsCheckedAgainst() {
        var lists = LibraryLists.fixture()
        lists.equipmentList = .fixture(equipment: [.fixture("oven")])
        #expect(Lesson.fixture().issues(in: lists) == [.unknownEquipment("stovetop")])
    }
}
