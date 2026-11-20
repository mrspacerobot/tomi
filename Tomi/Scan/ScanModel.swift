import CoreGraphics
import Foundation
import OSLog
import TomiCore

/// The fridge scan from the photo to tonight's menu. Proof of concept: nothing asks the cook yet, and the server
/// keeps every photo. A consent step must come before real cooks use it.
@Observable
final class ScanModel {
    static let logger = Logger(category: .scan)

    var stage = ScanStage.ready
    var problem: ProblemText?
    var list = ConfirmList()
    var previewPhoto: CGImage?
    private(set) var scanID: ScanID?
    let api: any TomiAPI
    let profile: ProfileModel

    init(api: any TomiAPI, profile: ProfileModel) {
        self.api = api
        self.profile = profile
    }

    func typeInstead() {
        stage = .confirming
    }

    func fail(_ error: any Error, then next: ScanStage) {
        Self.logger.error("The scan step failed: \(String(describing: error), privacy: .public)")
        problem = ProblemText(error)
        stage = next
    }

    func remember(_ result: ScanResult) {
        scanID = result.scanID
        list = ConfirmList(items: result.items.map(ConfirmItem.init))
        problem = nil
        stage = .confirming
    }
}
