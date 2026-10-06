import Testing

@testable import TomiCore

@Suite struct EquipmentListLookupTests {
    let list = EquipmentList.fixture()

    @Test func theListKnowsWhatItNames() {
        #expect(list.contains("oven"))
        #expect(list.contains("blender"))
    }

    @Test(arguments: ["stovtop", "Oven", "", "wok"])
    func theListDoesNotKnowAnythingElse(id: String) {
        #expect(!list.contains(EquipmentID(rawValue: id)))
    }

    @Test func theStandardKitchenIsWhatAKitchenIsAssumedToHave() {
        #expect(list.standardKitchen == ["stovetop", "oven"])
    }

    @Test func equipmentFollowsTheStandardKitchenUntilTheCookChooses() {
        var preferences = CookPreferences()
        #expect(preferences.equipment(assumingUntilChosen: list) == ["stovetop", "oven"])
        preferences.chosenEquipment = ["blender"]
        #expect(preferences.equipment(assumingUntilChosen: list) == ["blender"])
        preferences.chosenEquipment = []
        #expect(preferences.equipment(assumingUntilChosen: list).isEmpty)
    }
}
