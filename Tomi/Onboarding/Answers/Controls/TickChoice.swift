import TomiCore

/// One row of a question: an id from the server's list, or nil for the app's own "none" row, and its words.
struct TickChoice: Identifiable, Hashable {
    let optionID: OptionID?
    let name: String
    var note: String?

    var id: String {
        guard let optionID else {
            return ""
        }
        return optionID.rawValue
    }
}
