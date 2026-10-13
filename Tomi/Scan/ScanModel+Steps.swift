import Foundation
import TomiCore

extension ScanModel {
    /// The cook said yes to the scan, and maybe to keeping the photo, which is its own consent.
    func agree() async {
        do {
            try await api.agree(to: .photoScan, version: ConsentText.version(for: .photoScan))
            if keepsPhoto && offersToKeepPhoto {
                try await api.agree(to: .photoDataset, version: ConsentText.version(for: .photoDataset))
            }
            stage = .ready
        } catch {
            fail(error, then: .consent)
        }
    }

    func send(jpeg: Data) async {
        stage = .reading
        do {
            remember(try await api.scan(jpeg: jpeg))
        } catch let error as BackendError where error.code == .consentRequired {
            fail(error, then: .consent)
        } catch {
            fail(error, then: .confirming)
        }
    }

    func photoFailed() {
        fail(JPEGConversionError.unreadable, then: .ready)
    }

    /// Asks the server for tonight's special and shows only the offers it checked for this cook.
    func findSpecial() async {
        stage = .finding
        do {
            let request = SpecialsRequest(ingredients: list.confirmedIngredients, scanID: scanID)
            let menu = TonightsMenu(try await api.specials(request), for: profile.profile)
            problem = nil
            stage = stageShowing(menu)
        } catch {
            fail(error, then: .confirming)
        }
    }

    private func stageShowing(_ menu: TonightsMenu) -> ScanStage {
        if menu.isEmpty {
            return .nothingTonight
        }
        return .menu(menu)
    }
}
