import SwiftUI

/// Shown when the cook's answers could not be fetched, with a way to try again.
struct LoadFailedView: View {
    let flow: AppFlowModel

    var body: some View {
        ScrollView {
            VStack(spacing: ShowSize.rowGap) {
                OffAirTestPattern()
                Text(.loadFailedTitle).textStyle(.showTitle).accessibilityAddTraits(.isHeader)
                if let problem = flow.problem { ProblemView(problem: problem) }
                OffAirPortrait()
                RetryButton(flow: flow)
            }
            .padding(ShowSize.edge)
        }
        .multilineTextAlignment(.center)
        .background { ShowStage() }
    }
}

#Preview("Morning") { LoadFailedView(flow: .preview()).preferredColorScheme(.light) }
#Preview("Evening") { LoadFailedView(flow: .preview()).preferredColorScheme(.dark).dynamicTypeSize(.accessibility5) }
