import Foundation
import Testing

@testable import TomiCore

/// Checks the equipment list the app ships, so a content mistake fails here without needing the simulator.
@Suite struct ShippedEquipmentListTests {
    @Test func theShippedListIsValid() throws {
        let list = try ShippedEquipmentList.load()
        #expect(!list.equipment.isEmpty)
    }

    @Test func theShippedListIsTheKitchenScreenOfTheMockupsInItsOrder() throws {
        let list = try ShippedEquipmentList.load()
        #expect(list.equipment.map(\.id) == ShippedEquipmentList.mockupKitchen)
    }

    @Test func theStandardKitchenIsWhatTheKitchenScreenShowsTicked() throws {
        let list = try ShippedEquipmentList.load()
        #expect(list.standardKitchen == ShippedEquipmentList.mockupTicked)
    }

    @Test func everyShippedPieceOfEquipmentHasADistinctName() throws {
        let list = try ShippedEquipmentList.load()
        let names = list.equipment.map { $0.name.resolved(preferredLanguages: ["en"]) }
        #expect(Set(names).count == names.count)
    }

    @Test func aCookWhoHasNotAnsweredCanMakeEveryShippedLesson() throws {
        let kitchen = CookPreferences().equipment(assumingUntilChosen: try ShippedEquipmentList.load())
        for file in try ShippedLessons.files() {
            let lesson = try ShippedLessons.lesson(at: file)
            #expect(lesson.equipment.isSubset(of: kitchen), "\(lesson.id.rawValue)")
        }
    }

    @Test func equipmentThatIsNotShippedIsNotKnown() throws {
        #expect(try !ShippedEquipmentList.load().contains("stovtop"))
    }
}
