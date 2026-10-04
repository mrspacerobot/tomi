import Testing

@testable import TomiCore

/// A lesson names the food its scenes draw. The list is closed, because each one is a drawing in the scene kit.
@Suite struct LessonMainTests {
    @Test(arguments: DishMain.allCases)
    func everyMainOfTheKitIsAccepted(main: DishMain) {
        var lesson = Lesson.fixture()
        lesson.mainName = main.rawValue
        #expect(lesson.main == main)
        #expect(lesson.issuesInTheFixtureLibrary().isEmpty)
    }

    @Test func aMainOutsideTheClosedListIsReported() {
        var lesson = Lesson.fixture()
        lesson.mainName = "lobster"
        #expect(lesson.main == nil)
        #expect(lesson.issuesInTheFixtureLibrary() == [.unknownMain("lobster")])
    }

    @Test func aLessonFileNamesItsMain() throws {
        #expect(try LessonFile.decode(LessonFile.text()).main == .tofu)
    }

    @Test func aLessonFileWithoutAMainIsRejected() {
        let withoutMain = LessonFile.text().replacing(#""main": "tofu", "#, with: "")
        #expect(throws: DecodingError.self) {
            try LessonFile.decode(withoutMain)
        }
    }
}
