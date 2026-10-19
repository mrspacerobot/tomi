import Foundation
import Testing

@testable import Tomi

/// Renders the app icon into the asset catalog. Runs only when asked, through `scripts/render-app-icon.sh`,
/// which sets `TOMI_RENDER_APP_ICON` for the test runner.
@MainActor struct AppIconExportTests {
    nonisolated static let isRequested = ProcessInfo.processInfo.environment["TOMI_RENDER_APP_ICON"] == "1"

    @Test(.enabled(if: isRequested), arguments: AppIconAppearance.allCases)
    func renderTheIconIntoTheAssetCatalog(_ appearance: AppIconAppearance) throws {
        let image = try #require(RenderedAppIcon.image(appearance))
        #expect(RenderedAppIcon.write(image, to: appearance.shippedFile))
    }
}
