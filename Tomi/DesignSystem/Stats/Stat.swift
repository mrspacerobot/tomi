/// One column of the stats: a heading, the value and a line about it, already worded and formatted.
nonisolated struct Stat: Hashable, Sendable {
    let label: String
    let value: String
    let detail: String
}
