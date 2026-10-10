import Foundation

extension JPEGConversionError {
    var problemText: LocalizedStringResource {
        switch self {
        case .unreadable: .problemPhotoUnreadable
        case .tooLarge: .problemPhotoTooLarge
        }
    }
}
