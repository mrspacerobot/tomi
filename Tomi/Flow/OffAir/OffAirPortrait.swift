import SwiftUI

struct OffAirPortrait: View {
    var body: some View {
        TomiMascot(mood: .thinking)
            .frame(width: MascotSize.welcome, height: MascotSize.welcome)
            .accessibilityHidden(true)
    }
}

#Preview { OffAirPortrait().padding().background { ShowStage() } }
