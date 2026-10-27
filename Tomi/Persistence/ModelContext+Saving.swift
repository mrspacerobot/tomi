import SwiftData

extension ModelContext {
    /// Makes the changes and saves them. If either fails, the half-made changes are taken back,
    /// so the store never holds something the caller was told had failed.
    func saveOrRollBack(_ changes: () throws -> Void) throws {
        do {
            try changes()
            try save()
        } catch {
            rollback()
            throw error
        }
    }
}
