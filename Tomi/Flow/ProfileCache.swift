import Foundation
import TomiCore

/// Keeps the phone's copy of the server's profile.
struct ProfileCache {
    let store: any ProgressStore

    func keep(_ fresh: CookProfile, at moment: Date) throws {
        try store.saveProfile(fresh, at: moment)
    }
}
