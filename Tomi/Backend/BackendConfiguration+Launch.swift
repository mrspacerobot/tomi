import Foundation

nonisolated extension BackendConfiguration {
    /// The configuration a launch asks for. `--local-backend` swaps the deployed server for the one on this Mac
    /// and keeps the real sign-in, so a server change can be tried before it is deployed. Nil when the build names
    /// no server for the launch: a local launch never falls back to the deployed server.
    static func read(for options: BackendLaunchOptions, from bundle: Bundle = .main) -> BackendConfiguration? {
        guard let deployed = read(from: bundle) else {
            return nil
        }
        guard options.usesLocalAPI else {
            return deployed
        }
        guard let local = url(forKey: localAPIBaseURLKey, in: bundle) else {
            return nil
        }
        return deployed.talking(to: local)
    }

    /// The same sign-in with another server.
    private func talking(to apiBaseURL: URL) -> BackendConfiguration {
        BackendConfiguration(apiBaseURL: apiBaseURL, supabaseURL: supabaseURL, publishableKey: publishableKey)
    }
}
