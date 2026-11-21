import Foundation

extension ProfileQuestion {
    var interviewPrompt: LocalizedStringResource {
        switch self {
        case .diet: .openingInterviewDiet
        case .avoid: .openingInterviewAvoid
        case .kitchen: .openingInterviewKitchen
        case .cupboard: .openingInterviewCupboard
        case .cuisines: .openingInterviewCuisines
        case .experience: .openingInterviewExperience
        case .table: .openingInterviewTable
        }
    }

    var hostPose: CompanionState {
        switch self {
        case .diet, .kitchen, .cupboard: .explaining
        case .avoid: .listening
        case .experience: .thinking
        case .cuisines, .table: .idle
        }
    }
}
