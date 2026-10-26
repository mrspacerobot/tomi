/// Where a skill stands on the menu. A status this app does not know refuses the snapshot.
public enum SnapshotSkillStatus: String, Hashable, Decodable, Sendable {
    case locked, served, mastered
}
