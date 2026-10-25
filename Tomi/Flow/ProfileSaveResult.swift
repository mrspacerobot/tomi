/// How saving the cook's answers ended.
enum ProfileSaveResult: Equatable {
    case saved
    /// The change removes a diet or an avoid item. The screen asks the cook, then saves again with their yes.
    case needsConfirmation
}
