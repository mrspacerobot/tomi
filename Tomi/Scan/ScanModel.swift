import Foundation
import OSLog
import TomiCore

/// The fridge scan from consent to tonight's menu. The photo goes to the server only after the cook's
/// `photo-scan` consent; it is kept there only with the separate `photo-dataset` consent, off by default.
@Observable
final class ScanModel {
    static let logger = Logger(category: .scan)

    var stage = ScanStage.checking
    var problem: ProblemText?
    var list = ConfirmList()
    /// The cook's choice on the consent screen to let Tomi keep the photo. Off until they turn it on.
    var keepsPhoto = false
    /// The server asks for a newer consent text than this build has, so it cannot ask; the cook types instead.
    private(set) var consentTextIsOutdated = false
    private(set) var scanID: ScanID?
    let api: any TomiAPI
    let profile: ProfileModel

    init(api: any TomiAPI, profile: ProfileModel) {
        self.api = api
        self.profile = profile
    }

    func start() async {
        do {
            let consents = try await api.consents()
            stage = stageFor(consents)
        } catch {
            fail(error, then: .confirming)
        }
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

    private func stageFor(_ consents: [ConsentStatus]) -> ScanStage {
        guard let scan = consents.first(where: { $0.purpose == .photoScan }), ConsentText.isCurrent(scan) else {
            consentTextIsOutdated = true
            return .confirming
        }
        if scan.agreed {
            return .ready
        }
        return .consent
    }
}
