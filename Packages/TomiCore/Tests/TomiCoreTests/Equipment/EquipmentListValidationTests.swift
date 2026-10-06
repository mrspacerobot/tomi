import Testing

@testable import TomiCore

@Suite struct EquipmentListValidationTests {
    let stovetop = Equipment.fixture("stovetop")
    let blender = Equipment.fixture("blender", isAssumed: false)

    @Test func theFixtureIsValid() {
        #expect(EquipmentList.fixture().issues.isEmpty)
    }

    @Test func aListNamesAtLeastOnePieceOfEquipment() {
        #expect(EquipmentList.fixture(equipment: []).issues == [.noEquipment])
    }

    @Test func anEquipmentIDMayAppearOnlyOnce() {
        let sameIDNotAssumed = Equipment.fixture("stovetop", isAssumed: false)
        let list = EquipmentList.fixture(equipment: [stovetop, blender, sameIDNotAssumed])
        #expect(list.issues == [.duplicateEquipment("stovetop")])
    }

    @Test(arguments: ["", "  "])
    func anEquipmentIDIsNeverBlank(id: String) {
        let blank = Equipment.fixture(EquipmentID(rawValue: id))
        let list = EquipmentList.fixture(equipment: [stovetop, blank, blender])
        #expect(list.issues == [.blankEquipmentID(position: 1)])
    }

    @Test(arguments: [LocalizedText([:]), LocalizedText(["en": " "]), LocalizedText(["fr": "Four"])])
    func everyPieceOfEquipmentHasAnEnglishNameAndSummary(text: LocalizedText) {
        let nameless = EquipmentList.fixture(equipment: [stovetop, blender.with(name: text)])
        let unexplained = EquipmentList.fixture(equipment: [stovetop, blender.with(summary: text)])
        #expect(nameless.issues == [.missingEquipmentText("blender")])
        #expect(unexplained.issues == [.missingEquipmentText("blender")])
    }

    /// A cook who skips the kitchen question would be offered no dish that needs anything.
    @Test func aKitchenIsAssumedToHaveSomething() {
        let list = EquipmentList.fixture(equipment: [blender])
        #expect(list.issues == [.nothingAssumed])
    }

    @Test func everyProblemIsReportedAtOnce() {
        let blank = Equipment.fixture("")
        let nameless = blender.with(name: LocalizedText([:]))
        let list = EquipmentList.fixture(equipment: [blank, stovetop, stovetop, nameless])
        let expected: [EquipmentIssue] = [
            .blankEquipmentID(position: 0), .duplicateEquipment("stovetop"), .missingEquipmentText("blender"),
        ]
        #expect(list.issues == expected)
    }
}
