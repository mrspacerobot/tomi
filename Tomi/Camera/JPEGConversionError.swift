/// Why a photo could not be made into a JPEG for the server.
nonisolated enum JPEGConversionError: Error {
    case unreadable
    case tooLarge
}
