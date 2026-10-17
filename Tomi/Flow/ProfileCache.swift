import Foundation
import TomiCore

/// Keeps the phone's copy of the server's profile. When the cook's diet or avoid list is not what the copy
/// said, the lesson in progress is forgotten: it was offered for the old answers and only the server can check it.
struct ProfileCache {
    let store: any ProgressStore

    func keep(_ fresh: CookProfile, at moment: Date) throws {
        let cached = try store.profile()
        if !cached.hasSameRestrictions(as: fresh) {
            try store.clearActiveLesson()
        }
        try store.saveProfile(fresh, at: moment)
    }
}
