import TomiCore

/// The server's refusals of a profile change, imitated for the fake server only. The real rules are the server's.
nonisolated struct FakeProfileRules {
    let stored: ProfileEnvelope

    func check(_ patch: ProfilePatch) throws {
        guard patch.version == stored.version else {
            var conflict = APIError(codeName: APIErrorCode.versionConflict.rawValue, message: "")
            conflict.currentProfile = stored
            throw BackendError.server(status: 409, conflict)
        }
        if weakens(patch) && !patch.allowsWeakerRestrictions {
            throw Self.refusal(.weakensRestrictions, status: 409)
        }
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
