@testable import TomiCore

extension Equipment {
    /// A piece of equipment with English text. A kitchen is assumed to have it unless the test says otherwise.
    static func fixture(_ id: EquipmentID, isAssumed: Bool = true) -> Equipment {
        let name = LocalizedText(["en": "Equipment \(id.rawValue)"])
        return Equipment(id: id, name: name, summary: LocalizedText(["en": "What it is for"]), isAssumed: isAssumed)
    }

    func with(name: LocalizedText) -> Equipment {
        Equipment(id: id, name: name, summary: summary, isAssumed: isAssumed)
    }

    func with(summary: LocalizedText) -> Equipment {
        Equipment(id: id, name: name, summary: summary, isAssumed: isAssumed)
    }
}
