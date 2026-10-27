import Foundation

/// How the fake server answers each fresh read of the cook's profile, for UI tests. A cook never passes these.
nonisolated struct FakeProfileRefreshOptions: Equatable {
    static let failsArgument = "--fake-profile-refresh-fails"
    static let changesArgument = "--fake-profile-refresh-changes"
    static let waitsArgument = "--fake-profile-refresh-waits"

    let fails: Bool
    let changes: Bool
    let waits: Bool

    init(arguments: [String]) {
        fails = arguments.contains(Self.failsArgument)
        changes = arguments.contains(Self.changesArgument)
        waits = arguments.contains(Self.waitsArgument)
    }
}
