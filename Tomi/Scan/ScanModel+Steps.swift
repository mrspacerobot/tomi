import Foundation
import TomiCore

extension ScanModel {
    func send(jpeg: Data) async {
        previewPhoto = JPEGConverter.preview(from: jpeg)
        stage = .reading
        do {
            remember(try await api.scan(jpeg: jpeg))
        } catch {
            fail(error, then: .confirming)
        }
    }

    func photoFailed() {
        fail(JPEGConversionError.unreadable, then: .ready)
    }

    /// Asks the server for tonight's special and shows only the suggestions it checked for this cook.
    func findSuggestions() async {
        stage = .finding
        do {
            let request = SuggestionsRequest(ingredients: list.confirmedIngredients, scanID: scanID)
            let menu = TonightsMenu(try await api.suggestions(request), for: profile.profile)
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
