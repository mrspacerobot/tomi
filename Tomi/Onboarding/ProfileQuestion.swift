/// The questions about the cook. Their lists come from the server; their order and words are the app's.
enum ProfileQuestion: CaseIterable, Hashable {
    case diet
    case avoid
    case cuisines
    case kitchen
    case cupboard
    case experience
    case table

    /// Onboarding asks these in order. The cupboard waits for settings, so a first evening is quick.
    static let onboarding: [ProfileQuestion] = [.diet, .avoid, .cuisines, .kitchen, .experience, .table]
}
