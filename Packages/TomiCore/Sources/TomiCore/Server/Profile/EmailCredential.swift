/// The checks made before an email and password are sent, so a typo is caught on the phone.
/// The server stays the authority: it applies its own rules again.
public enum EmailCredential {
    /// Supabase Auth's default minimum.
    public static let minimumPasswordLength = 6

    public static func isPlausibleAddress(_ address: String) -> Bool {
        let parts = address.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2, !parts[0].isEmpty, !parts[0].contains(" ") else {
            return false
        }
        return isPlausibleDomain(parts[1])
    }

    public static func isAcceptablePassword(_ password: String) -> Bool {
        password.count >= minimumPasswordLength
    }

    private static func isPlausibleDomain(_ domain: Substring) -> Bool {
        let labels = domain.split(separator: ".", omittingEmptySubsequences: false)
        guard labels.count >= 2 else {
            return false
        }
        return labels.allSatisfy { !$0.isEmpty && !$0.contains(" ") }
    }
}
