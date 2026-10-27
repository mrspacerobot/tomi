import Foundation
import TomiCore

extension ProgressStore {
    /// Does what the server's answer says to one cook of the outbox: forgets it, or marks it refused with the
    /// server's code.
    func apply(_ change: OutboxChange, to id: UUID) throws {
        switch change {
        case .forget:
            try forgetCookEntries(ids: [id])
        case .refuse(let code):
            try markCookEntryRefused(id: id, code: code)
        }
    }
}
