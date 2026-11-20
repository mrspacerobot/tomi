import SwiftUI

/// The screen for each stage of the scan.
struct ScanStageView: View {
    let model: ScanModel
    let flow: AppFlowModel
    @Binding var path: [HomeRoute]

    var body: some View {
        switch model.stage {
        case .reading, .finding: ScanWaitingView(stage: model.stage, photo: model.previewPhoto)
        case .ready: ScanReadyView(model: model, photos: flow.services.photos)
        case .confirming: ConfirmView(model: model)
        case .menu(let menu): SuggestionsView(menu: menu, options: flow.profile.listedOptions, path: $path)
        case .nothingTonight: NothingTonightView(model: model, path: $path)
        }
    }
}
