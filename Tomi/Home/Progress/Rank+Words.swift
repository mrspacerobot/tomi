import Foundation
import TomiCore

extension Rank {
    /// The rank name for the progress column. Past the first tier of the top rank the tier number follows it.
    var words: String {
        let name = String(localized: title.localizationKey)
        guard tier > 1 else { return name }
        return String(localized: .homeRankTiered(name, tier))
    }
}
