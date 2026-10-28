import Foundation
import TomiCore

extension APIErrorCode {
    /// Tomi's words for each error of the server.
    nonisolated var problemText: LocalizedStringResource {
        switch self {
        case .unauthenticated, .anonymousNotAllowed: .problemSignedOut
        case .accountDeleted: .problemAccountDeleted
        case .photoTooLarge: .problemPhotoTooLarge
        case .photoUnreadable: .problemPhotoUnreadable
        case .aiUnavailable: .problemAiUnavailable
        case .graphUnavailable: .problemGraphUnavailable
        case .graphVersionChanged: .problemGraphVersionChanged
        case .versionConflict, .weakensRestrictions, .invalidRequest: .problemNotSaved
        case .notFound, .authUnavailable, .internalError: .problemGeneric
        }
    }
}
