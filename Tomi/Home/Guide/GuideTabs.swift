import SwiftUI

struct GuideTabs: View {
    @Binding var path: [HomeRoute]

    var body: some View {
        ShowTabBar(items: GuideTab.items, selection: selection)
            .padding(.horizontal, ShowSize.edge)
            .padding(.vertical, ShowSize.compact)
            .background(ColorRole.stage.color)
    }

    private var selection: Binding<GuideTab> {
        Binding(get: { .guide }, set: open)
    }

    private func open(_ tab: GuideTab) {
        if let route = tab.route {
            path.append(route)
        }
    }
}

#Preview { GuideTabs(path: .constant([])).background { ShowStage() } }
