/// The error codes of the server the app acts on. The raw values are the server's, permanent once released.
public enum APIErrorCode: String, CaseIterable, Hashable, Sendable {
    case unauthenticated
    case anonymousNotAllowed = "anonymous_not_allowed"
    case accountDeleted = "account_deleted"
    case invalidRequest = "invalid_request"
    case notFound = "not_found"
    case versionConflict = "version_conflict"
    case weakensRestrictions = "weakens_restrictions"
    case photoTooLarge = "photo_too_large"
    case photoUnreadable = "photo_unreadable"
    case aiUnavailable = "ai_unavailable"
    case graphUnavailable = "graph_unavailable"
    case authUnavailable = "auth_unavailable"
    case internalError = "internal"
}
