import Foundation
import TomiCore

extension SnapshotRank {
    /// The rank as the server names it. Past the first tier the server's tier number follows the name.
    var words: String {
        guard tier > 1 else { return name }
        return String(localized: .homeRankTiered(name, tier))
    }
}
