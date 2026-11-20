import Foundation
import ImageIO

/// Fetches and decodes the dish photos the server names. The app uses the shared session; fake launches use a
/// session answered by `FakeDishPhotoProtocol`, so previews and UI tests never reach the network.
nonisolated struct DishPhotoLoader: Sendable {
    static let live = DishPhotoLoader(session: .shared)

    let session: URLSession

    static var fake: DishPhotoLoader {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeDishPhotoProtocol.self]
        return DishPhotoLoader(session: URLSession(configuration: configuration))
    }

    /// The photo, or nil when it cannot be fetched or read. The card then shows without it.
    func image(at url: URL) async -> CGImage? {
        do {
            let (data, _) = try await session.data(from: url)
            return Self.decode(data)
        } catch {
            return nil
        }
    }

    private static func decode(_ data: Data) -> CGImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        return CGImageSourceCreateImageAtIndex(source, 0, nil)
    }
}
