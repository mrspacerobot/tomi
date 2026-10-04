import Foundation
import Testing

@testable import TomiCore

@Suite struct EquipmentListDecodingTests {
    @Test func aValidListDecodes() throws {
        let file = EquipmentListFile.data(equipment: "[\(EquipmentListFile.stovetop), \(EquipmentListFile.blender)]")
        let list = try EquipmentList.decode(from: file)
        let stovetop = try #require(list.equipment.first)
        #expect(list.equipment.map(\.id) == ["stovetop", "blender"])
        #expect(stovetop.name.resolved(preferredLanguages: []) == "Stovetop")
        #expect(stovetop.summary.resolved(preferredLanguages: []) == "Every pan dish")
        #expect(list.equipment.map(\.isAssumed) == [true, false])
    }

    @Test func aListSurvivesARoundTripThroughJSON() throws {
        let list = EquipmentList.fixture()
        #expect(try EquipmentList.decode(from: JSONEncoder().encode(list)) == list)
    }

    @Test(arguments: [0, EquipmentList.supportedSchemaVersion + 1])
    func anUnknownSchemaVersionIsRejectedBeforeReadingTheRest(version: Int) {
        let file = EquipmentListFile.data(schemaVersion: version, equipment: #""a shape from the future""#)
        #expect(throws: EquipmentListError.unsupportedSchemaVersion(version)) {
            try EquipmentList.decode(from: file)
        }
    }

    @Test(arguments: [#"{"equipment": []}"#, "not json", ""])
    func aFileWithoutASchemaVersionIsRejected(file: String) {
        #expect(throws: DecodingError.self) {
            try EquipmentList.decode(from: Data(file.utf8))
        }
    }

    @Test(arguments: [
        #"{"name": {"en": "Oven"}, "summary": {"en": "Roasting"}, "assumed": true}"#,
        #"{"id": "oven", "summary": {"en": "Roasting"}, "assumed": true}"#,
        #"{"id": "oven", "name": {"en": "Oven"}, "assumed": true}"#,
        #"{"id": "oven", "name": {"en": "Oven"}, "summary": {"en": "Roasting"}}"#,
    ])
    func equipmentMissingAFieldIsRejectedRatherThanGivenADefault(equipment: String) {
        #expect(throws: DecodingError.self) {
            try EquipmentList.decode(from: EquipmentListFile.data(equipment: "[\(equipment)]"))
        }
    }

    @Test(arguments: ["assume", "standard", "description"])
    func aFieldThisBuildDoesNotReadIsRejectedRatherThanIgnored(field: String) {
        let oven = #"{"id": "oven", "name": {"en": "Oven"}, "summary": {"en": "Roasting"}, "assumed": true"#
        let file = EquipmentListFile.data(equipment: #"[\#(oven), "\#(field)": true}]"#)
        #expect(throws: DecodingError.self) {
            try EquipmentList.decode(from: file)
        }
    }

    @Test(arguments: ["equipments", "libraryVersion"])
    func aFieldOfTheListThisBuildDoesNotReadIsRejected(field: String) {
        let equipment = "[\(EquipmentListFile.stovetop)]"
        let file = #"{"schemaVersion": 1, "equipment": \#(equipment), "\#(field)": []}"#
        #expect(throws: DecodingError.self) {
            try EquipmentList.decode(from: Data(file.utf8))
        }
    }

    @Test func anInvalidListIsRejectedWithItsIssues() {
        let file = EquipmentListFile.data(equipment: "[\(EquipmentListFile.stovetop), \(EquipmentListFile.stovetop)]")
        #expect(throws: EquipmentListError.invalid([.duplicateEquipment("stovetop")])) {
            try EquipmentList.decode(from: file)
        }
    }
}
