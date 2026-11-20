import SwiftUI

/// The answers of one question.
struct QuestionAnswers: View {
    let question: ProfileQuestion
    let draft: AnswersDraft

    var body: some View {
        switch question {
        case .diet: DietAnswers(draft: draft)
        case .avoid: AvoidAnswers(draft: draft)
        case .cuisines: CuisineAnswers(draft: draft)
        case .kitchen: KitchenAnswers(draft: draft)
        case .cupboard: CupboardAnswers(draft: draft)
        case .experience: ExperienceAnswers(draft: draft)
        case .table: TableAnswers(draft: draft)
        }
    }
}
