/// One way an equipment list can be wrong. The validator lists them all so a library build can report every problem.
/// A blank id is found by where it sits in the list, counting from 0, since it has no name to report.
public enum EquipmentIssue: Hashable, Sendable {
    /// An empty list would make every piece of equipment unknown.
    case noEquipment
    case blankEquipmentID(position: Int)
    case duplicateEquipment(EquipmentID)
    /// The name or the summary has no English text.
    case missingEquipmentText(EquipmentID)
    /// A kitchen assumed to have nothing would hide every dish that needs equipment
    /// from a cook who skips the kitchen question.
    case nothingAssumed
}
