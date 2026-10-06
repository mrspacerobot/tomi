import Foundation
import Testing
import TomiCore

@testable import Tomi

@Suite struct BundledEquipmentListTests {
    @Test func theEquipmentListShipsInTheAppAndIsValid() throws {
        let list = try EquipmentList.decode(from: BundledLibrary.equipmentListData())
        #expect(!list.equipment.isEmpty)
        #expect(BundledLibrary.equipmentList() == list)
    }

    @Test func everyPieceOfEquipmentReadsInTheCooksLanguage() throws {
        let list = try #require(BundledLibrary.equipmentList())
        for equipment in list.equipment {
            #expect(!equipment.name.resolved(preferredLanguages: Locale.preferredLanguages).isEmpty)
            #expect(!equipment.summary.resolved(preferredLanguages: Locale.preferredLanguages).isEmpty)
        }
    }

    @Test func aCookWhoHasNotAnsweredCanMakeEveryShippedLesson() throws {
        let library = BundledLessonLibrary()
        let kitchen = CookPreferences().equipment(assumingUntilChosen: try #require(library.equipmentList))
        #expect(!kitchen.isEmpty)
        for lesson in library.lessons {
            #expect(lesson.equipment.isSubset(of: kitchen), "\(lesson.id.rawValue)")
        }
    }

    @Test func aMissingListGivesNoList() throws {
        #expect(BundledLibrary.equipmentList(in: try Bundle.fixture(equipment: nil)) == nil)
    }

    @Test(arguments: ["", "not json", #"{"schemaVersion": 99}"#, #"{"schemaVersion": 1}"#])
    func anUnreadableListGivesNoList(contents: String) throws {
        let bundle = try Bundle.fixture(equipment: Data(contents.utf8))
        #expect(BundledLibrary.equipmentList(in: bundle) == nil)
    }

    @Test(arguments: [
        "",
        #"{"id": "wok", "name": {"en": "Wok"}, "summary": {"en": "Stir-fries"}}"#,
        #"{"id": "wok", "name": {"en": "Wok"}, "summary": {"en": "Stir-fries"}, "assumed": false}"#,
        #"{"id": "wok", "name": {"en": "Wok"}, "summary": {"en": "Stir-fries"}, "assumed": true, "standard": true}"#,
    ])
    func aListWithNoEquipmentOrAWrongOneGivesNoList(equipment: String) throws {
        let contents = #"{"schemaVersion": 1, "equipment": [\#(equipment)]}"#
        let bundle = try Bundle.fixture(equipment: Data(contents.utf8))
        #expect(BundledLibrary.equipmentList(in: bundle) == nil)
    }

    @Test func aValidListInAnyBundleIsRead() throws {
        let bundle = try Bundle.fixture(equipment: BundledLibrary.equipmentListData())
        #expect(BundledLibrary.equipmentList(in: bundle) == BundledLibrary.equipmentList())
    }
}
