import Foundation

@testable import TomiCore

/// The equipment list the app ships, read straight from the app's resources so no simulator is needed.
enum ShippedEquipmentList {
    static let url = ShippedLibrary.folder.appending(path: "equipment.json")

    static func load() throws -> EquipmentList {
        try EquipmentList.decode(from: Data(contentsOf: url))
    }

    /// The kitchen screen of the mockups (`KITCHEN` in `docs/design/src/round2.py`), in the order it is drawn.
    static let mockupKitchen: [EquipmentID] = [
        "stovetop", "oven", "microwave", "thermometer", "blender", "rice-cooker",
    ]

    /// The three the kitchen screen shows ticked before the cook touches anything.
    static let mockupTicked: Set<EquipmentID> = ["stovetop", "oven", "microwave"]
}
