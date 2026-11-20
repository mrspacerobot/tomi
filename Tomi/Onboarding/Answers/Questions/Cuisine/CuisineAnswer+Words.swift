import Foundation
import TomiCore

extension CuisineAnswer {
    var words: LocalizedStringResource {
        switch self {
        case .love: .questionCuisinesLove
        case .try: .questionCuisinesTry
        case .never: .questionCuisinesNever
        }
    }
}
