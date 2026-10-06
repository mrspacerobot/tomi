@testable import TomiCore

extension EquipmentList {
    /// Two things a kitchen is assumed to have and one it is not.
    static let fixtureEquipment: [Equipment] = [
        .fixture("stovetop"),
        .fixture("oven"),
        .fixture("blender", isAssumed: false),
    ]

    /// A valid list. Each test breaks it in one way.
    static func fixture(equipment: [Equipment] = fixtureEquipment) -> EquipmentList {
        EquipmentList(schemaVersion: EquipmentList.supportedSchemaVersion, equipment: equipment)
    }
}
