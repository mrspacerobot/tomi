import Foundation

/// Where the app finds Tomi's server and Supabase sign-in. Read from the Info.plist, which takes the values from
/// the build settings `TOMI_API_BASE_URL`, `TOMI_SUPABASE_URL` and `TOMI_SUPABASE_PUBLISHABLE_KEY`.
/// Nothing secret is here: the publishable key is meant to ship in apps. It is still never typed into a Swift file.
nonisolated struct BackendConfiguration: Equatable, Sendable {
    static let apiBaseURLKey = "TomiAPIBaseURL"
    static let supabaseURLKey = "TomiSupabaseURL"
    static let publishableKeyKey = "TomiSupabasePublishableKey"

    let apiBaseURL: URL
    let supabaseURL: URL
    let publishableKey: String

    /// The configuration of this build, or nil when any value is missing or blank.
    static func read(from bundle: Bundle = .main) -> BackendConfiguration? {
        guard let api = url(forKey: apiBaseURLKey, in: bundle), let supabase = url(forKey: supabaseURLKey, in: bundle)
        else {
            return nil
        }
        guard let key = text(forKey: publishableKeyKey, in: bundle) else {
            return nil
        }
        return BackendConfiguration(apiBaseURL: api, supabaseURL: supabase, publishableKey: key)
    }

    private static func url(forKey key: String, in bundle: Bundle) -> URL? {
        guard let text = text(forKey: key, in: bundle) else {
            return nil
        }
        return URL(string: text)
    }

    /// A value that is not blank. An unset build setting arrives as an empty string.
    private static func text(forKey key: String, in bundle: Bundle) -> String? {
        guard let value = bundle.object(forInfoDictionaryKey: key) as? String else {
            return nil
        }
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            return nil
        }
        return trimmed
    }
}
