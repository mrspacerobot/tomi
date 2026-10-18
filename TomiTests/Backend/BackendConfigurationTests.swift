import Foundation
import Testing

@testable import Tomi

/// Which server and sign-in a launch talks to. A plain launch uses the deployed server, `--local-backend`
/// swaps only the server for the one on this Mac and keeps the real sign-in.
@Suite struct BackendConfigurationTests {
    private let deployed = URL(string: "https://api.example.com")!
    private let local = URL(string: "http://localhost:8080")!
    private let supabase = URL(string: "https://project.supabase.co")!

    @Test func aPlainLaunchUsesTheDeployedServer() throws {
        let bundle = try Bundle.fixture(info: settings(localAPI: local))

        let configuration = BackendConfiguration.read(for: BackendLaunchOptions(arguments: []), from: bundle)

        #expect(configuration == BackendConfiguration(apiBaseURL: deployed, supabaseURL: supabase, publishableKey: "k"))
    }

    @Test func aLocalLaunchUsesTheServerOnThisMacWithTheRealSignIn() throws {
        let bundle = try Bundle.fixture(info: settings(localAPI: local))
        let options = BackendLaunchOptions(arguments: [BackendLaunchOptions.localBackendArgument])

        let configuration = BackendConfiguration.read(for: options, from: bundle)

        #expect(configuration == BackendConfiguration(apiBaseURL: local, supabaseURL: supabase, publishableKey: "k"))
    }

    /// Asking for the local server in a build that names none must not quietly talk to the deployed one.
    @Test func aLocalLaunchWithoutALocalServerIsNotConfigured() throws {
        let bundle = try Bundle.fixture(info: settings(localAPI: nil))
        let options = BackendLaunchOptions(arguments: [BackendLaunchOptions.localBackendArgument])

        #expect(BackendConfiguration.read(for: options, from: bundle) == nil)
    }

    @Test func aBlankSettingIsNotConfigured() throws {
        var info = settings(localAPI: local)
        info[BackendConfiguration.publishableKeyKey] = ""
        let bundle = try Bundle.fixture(info: info)

        #expect(BackendConfiguration.read(for: BackendLaunchOptions(arguments: []), from: bundle) == nil)
    }

    private func settings(localAPI: URL?) -> [String: String] {
        var info = [
            BackendConfiguration.apiBaseURLKey: deployed.absoluteString,
            BackendConfiguration.supabaseURLKey: supabase.absoluteString,
            BackendConfiguration.publishableKeyKey: "k",
        ]
        if let localAPI {
            info[BackendConfiguration.localAPIBaseURLKey] = localAPI.absoluteString
        }
        return info
    }
}
