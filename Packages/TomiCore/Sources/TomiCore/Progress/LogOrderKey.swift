/// Every field that tells two copies apart. Any fixed order will do, as long as it is the same everywhere.
struct LogOrderKey: Comparable {
    let words: [String]
    let numbers: [Int]
    /// Only breaks a tie that nothing else does.
    let zone: String
    let graphVersion: String?
    let account: String?

    static func < (left: LogOrderKey, right: LogOrderKey) -> Bool {
        if left.words != right.words {
            return left.words.lexicographicallyPrecedes(right.words)
        }
        if left.numbers != right.numbers {
            return left.numbers.lexicographicallyPrecedes(right.numbers)
        }
        if left.zone != right.zone {
            return left.zone < right.zone
        }
        return compareOwnersAndVersions(left, right)
    }

    private static func compareOwnersAndVersions(_ left: LogOrderKey, _ right: LogOrderKey) -> Bool {
        if left.graphVersion != right.graphVersion {
            return precedes(left.graphVersion, right.graphVersion)
        }
        return precedes(left.account, right.account)
    }

    private static func precedes(_ left: String?, _ right: String?) -> Bool {
        guard let left else {
            return right != nil
        }
        guard let right else {
            return false
        }
        return left < right
    }
}
