import SwiftUI
import TomiCore

/// The adapted recipe's preparation checklist before the guided steps begin.
struct CookingPreparationView: View {
    let suggestion: Suggestion
    let flow: AppFlowModel
    @Binding var path: [HomeRoute]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge) {
                Text(suggestion.title).textStyle(.displayM)
                CookingPreparationChecklist(suggestion: suggestion)
                CookingBeginStepsButton(suggestion: suggestion, flow: flow, path: $path)
                CookingReturnButton(path: $path)
            }
            .padding(Spacing.screenMargin)
        }
        .background(ColorRole.paper.color)
        .navigationTitle(Text(.cookingPreparationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }
}
