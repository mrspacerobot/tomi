import Foundation

/// How the fake server answers each fresh read of the cook's profile, for UI tests. A cook never passes these.
nonisolated struct FakeProfileRefreshOptions: Equatable {
    static let failsArgument = "--fake-profile-refresh-fails"
    static let changesArgument = "--fake-profile-refresh-changes"
    static let waitsArgument = "--fake-profile-refresh-waits"
    /// The read before preparation passes, and the one when the steps begin has different restrictions.
    static let changesLateArgument = "--fake-profile-refresh-changes-late"

    let fails: Bool
    let changes: Bool
    let waits: Bool
    let changesLate: Bool

    init(fails: Bool = false, changes: Bool = false, waits: Bool = false, changesLate: Bool = false) {
        self.fails = fails
        self.changes = changes
        self.waits = waits
        self.changesLate = changesLate
    }

    init(arguments: [String]) {
        fails = arguments.contains(Self.failsArgument)
        changes = arguments.contains(Self.changesArgument)
        waits = arguments.contains(Self.waitsArgument)
        changesLate = arguments.contains(Self.changesLateArgument)
    }
}
