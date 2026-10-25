import TomiCore

/// The server's refusals of a profile change, imitated for the fake server only. The real rules are the server's.
nonisolated struct FakeProfileRules {
    let stored: ProfileEnvelope
    let options: LibraryOptions

    func check(_ patch: ProfilePatch) throws {
        try checkVersion(of: patch)
        guard knowsEveryStaple(of: patch.after) else {
            throw Self.refusal(.invalidRequest, status: 422)
        }
        if weakens(patch) && !patch.allowsWeakerRestrictions {
            throw Self.refusal(.weakensRestrictions, status: 409)
        }
    }

    private func checkVersion(of patch: ProfilePatch) throws {
        guard patch.version == stored.version else {
            var conflict = APIError(codeName: APIErrorCode.versionConflict.rawValue, message: "")
            conflict.currentProfile = stored
            throw BackendError.server(status: 409, conflict)
        }
    }

    /// The server refuses a staple the ingredient graph does not know.
    private func knowsEveryStaple(of profile: CookProfile) -> Bool {
        let known = Set(options.ingredients.map(\.id))
        return profile.cupboardStaples.isSubset(of: known)
    }

    /// Clearing or changing the diet, or removing an avoid item.
    private func weakens(_ patch: ProfilePatch) -> Bool {
        let before = stored.profile
        let dietChanged = before.diet != nil && patch.after.diet != before.diet
        return dietChanged || !before.avoid.isSubset(of: patch.after.avoid)
    }

    static func refusal(_ code: APIErrorCode, status: Int) -> BackendError {
        BackendError.server(status: status, APIError(codeName: code.rawValue, message: ""))
    }
}
