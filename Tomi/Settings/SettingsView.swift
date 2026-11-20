import SwiftUI
import TomiCore

struct SettingsView: View {
    let flow: AppFlowModel
    var currentProgress: ShownProgress?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ShowSize.rowGap) {
                ShowBackButton { dismiss() }
                SettingsHeader(currentProgress: currentProgress)
                QuestionLinks()
                SignOutButton(flow: flow)
            }
            .padding(ShowSize.edge)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .background { ShowStage() }
    }
}

#Preview { NavigationStack { SettingsView(flow: .preview()) } }
