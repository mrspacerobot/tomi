import SwiftUI

struct EmailAuthLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textStyle(.showLede, color: .stageInk)
            .underline(configuration.isPressed)
            .frame(minHeight: TouchTarget.minimum, alignment: .leading)
    }
}
