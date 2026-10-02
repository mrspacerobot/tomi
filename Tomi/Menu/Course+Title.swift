import Foundation
import TomiCore

/// Display name of a course. The words themselves live in the string catalog.
extension Course {
    nonisolated var title: LocalizedStringResource {
        switch self {
        case .foundations: .courseFoundationsTitle
        case .heatControl: .courseHeatControlTitle
        case .buildingFlavor: .courseBuildingFlavorTitle
        case .puttingItTogether: .coursePuttingItTogetherTitle
        }
    }
}
