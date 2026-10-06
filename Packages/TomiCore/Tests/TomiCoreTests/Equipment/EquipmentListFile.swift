import Foundation

@testable import TomiCore

/// The text of an equipment list file for decoding tests, around the pieces of equipment a test writes.
enum EquipmentListFile {
    static let stovetop =
        #"{"id": "stovetop", "name": {"en": "Stovetop"}, "summary": {"en": "Every pan dish"}, "assumed": true}"#
    static let blender =
        #"{"id": "blender", "name": {"en": "Blender"}, "summary": {"en": "Smooth soups"}, "assumed": false}"#

    static func data(schemaVersion: Int = EquipmentList.supportedSchemaVersion, equipment: String) -> Data {
        Data(#"{"schemaVersion": \#(schemaVersion), "equipment": \#(equipment)}"#.utf8)
    }
}
