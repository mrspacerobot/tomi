import Foundation

extension EmailAuthModel {
    var cleanEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
