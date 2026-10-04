import Foundation
import Testing

@testable import TomiCore

/// Coverage is a ratchet. The list of known gaps is checked in, and it must match the shipped library exactly:
/// a new gap fails, and so does a gap that was closed but is still listed. So coverage can only improve.
@Suite struct LessonCoverageTests {
    @Test func theKnownGapsAreExactlyTheGapsOfTheShippedLibrary() throws {
        let gaps = try Self.shippedCoverage().gapLines()
        if KnownCoverageGaps.shouldRewrite {
            try KnownCoverageGaps.write(gaps)
        }
        let known = try KnownCoverageGaps.lines()
        #expect(Set(gaps).subtracting(known).sorted() == [], "new gaps that are not on the list")
        #expect(Set(known).subtracting(gaps).sorted() == [], "listed gaps that the library has closed")
    }

    @Test func aLevelWithNoLessonLacksEveryDiet() throws {
        let coverage = LessonCoverage(catalog: .fixture(), table: .fixture(), lessons: [])
        #expect(try coverage.gapLines().first == "knife 1: any vegetarian vegan pescatarian")
        #expect(try coverage.gapLines().count == 6)
    }

    @Test func aLessonCoversItsLevelForTheDietsItSuits() throws {
        let coverage = LessonCoverage(catalog: .fixture(), table: .fixture(), lessons: [.fixture()])
        #expect(try coverage.gapLines().contains("eggs 1: vegan"))
    }

    @Test func aSwapThatRemovesTheProblemCoversTheDiet() throws {
        var lesson = Lesson.fixture()
        lesson.swaps = [.fixture(replacing: "butter", with: "bacon"), .fixture(replacing: "butter", with: "garlic")]
        let coverage = LessonCoverage(catalog: .fixture(), table: .fixture(), lessons: [lesson])
        let eggsOne = try coverage.gapLines().filter { $0.hasPrefix("eggs 1:") }
        #expect(eggsOne == [])
    }

    private static func shippedCoverage() throws -> LessonCoverage {
        let catalog = try SkillCatalog.decode(from: Data(contentsOf: ShippedCatalogTests.catalogURL))
        var lessons: [Lesson] = []
        for file in try ShippedLessons.files() {
            lessons.append(try ShippedLessons.lesson(at: file))
        }
        return LessonCoverage(catalog: catalog, table: try ShippedIngredientTable.load(), lessons: lessons)
    }
}
