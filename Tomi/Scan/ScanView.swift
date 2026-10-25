import SwiftUI

/// The fridge scan: the photo, what the cook has tonight, then tonight's menu.
struct ScanView: View {
    let flow: AppFlowModel
    @Binding var path: [HomeRoute]
    @State private var model: ScanModel

    init(flow: AppFlowModel, path: Binding<[HomeRoute]>) {
        self.flow = flow
        _path = path
        _model = State(initialValue: ScanModel(api: flow.services.api, profile: flow.profile))
    }

    var body: some View {
        ScanStageView(model: model, flow: flow, path: $path)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorRole.paper.color)
    }
}

#Preview {
    NavigationStack {
        ScanView(flow: .preview(), path: .constant([]))
    }
}
