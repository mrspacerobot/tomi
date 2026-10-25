import TomiCore

/// Reads the cook's current profile from the server before preparation begins.
@MainActor protocol FreshProfileReading {
    func refreshProfile() async throws -> CookProfile
}

extension ProfileModel: FreshProfileReading {}
