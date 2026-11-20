/// The questions about the cook. Their lists come from the server; their order and words are the app's.
enum ProfileQuestion: CaseIterable, Hashable {
    case diet
    case avoid
    case cuisines
    case kitchen
    case cupboard
    case experience
    case table

    /// The order of the seven questions in the opening-night interview.
    static let onboarding: [ProfileQuestion] = [.diet, .avoid, .kitchen, .cupboard, .cuisines, .experience, .table]
}
