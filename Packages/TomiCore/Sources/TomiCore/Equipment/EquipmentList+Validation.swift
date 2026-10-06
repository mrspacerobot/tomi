/// The checks a hand-written equipment list must pass. Every library build and every load runs them.
extension EquipmentList {
    /// Every problem in the list, empty when it is fit to use.
    public var issues: [EquipmentIssue] {
        if equipment.isEmpty {
            return [.noEquipment]
        }
        var issues = equipment.map(\.id.rawValue).blankPositions.map(EquipmentIssue.blankEquipmentID)
        issues += equipment.map(\.id).duplicates.map(EquipmentIssue.duplicateEquipment)
        issues += equipment.filter(\.isMissingText).map { .missingEquipmentText($0.id) }
        return issues + standardKitchenIssues
    }

    private var standardKitchenIssues: [EquipmentIssue] {
        if standardKitchen.isEmpty {
            return [.nothingAssumed]
        }
        return []
    }
}

extension Equipment {
    /// Whether the name or the summary has no English text.
    fileprivate var isMissingText: Bool {
        name.isMissingSourceText || summary.isMissingSourceText
    }
}
