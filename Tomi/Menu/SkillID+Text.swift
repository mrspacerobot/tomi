import Foundation
import TomiCore

/// Display text of a technique. The words themselves live in the string catalog.
extension SkillID {
    nonisolated var name: LocalizedStringResource {
        switch self {
        case .knife: .skillKnifeName
        case .eggs: .skillEggsName
        case .boil: .skillBoilName
        case .saute: .skillSauteName
        case .sear: .skillSearName
        case .rice: .skillRiceName
        case .roast: .skillRoastName
        case .pansauce: .skillPansauceName
        case .emulsion: .skillEmulsionName
        case .pasta: .skillPastaName
        case .braise: .skillBraiseName
        case .balance: .skillBalanceName
        }
    }

    nonisolated var summary: LocalizedStringResource {
        switch self {
        case .knife: .skillKnifeSummary
        case .eggs: .skillEggsSummary
        case .boil: .skillBoilSummary
        case .saute: .skillSauteSummary
        case .sear: .skillSearSummary
        case .rice: .skillRiceSummary
        case .roast: .skillRoastSummary
        case .pansauce: .skillPansauceSummary
        case .emulsion: .skillEmulsionSummary
        case .pasta: .skillPastaSummary
        case .braise: .skillBraiseSummary
        case .balance: .skillBalanceSummary
        }
    }
}
