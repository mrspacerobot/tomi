import Foundation
import TomiCore

extension RankTitle {
    var localizationKey: LocalizedStringResource {
        switch self {
        case .novice: .rankNovice
        case .commis: .rankCommis
        case .cook: .rankCook
        case .saucier: .rankSaucier
        case .sous: .rankSous
        case .chef: .rankChef
        case .patron: .rankPatron
        case .toque: .rankToque
        }
    }
}
