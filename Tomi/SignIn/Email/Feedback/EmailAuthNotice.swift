import SwiftUI

struct EmailAuthNotice: View {
    let model: EmailAuthModel

    var body: some View {
        if let notice = model.notice {
            Text(notice)
                .textStyle(.showText, color: ink)
                .padding(ShowSize.cardVertical)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ground, in: .rect(cornerRadius: Radius.showControl))
                .accessibilityIdentifier(model.mode.noticeIdentifier)
        }
    }

    private var ink: ColorRole {
        if model.noticeIsError { return .showWhite }
        return .showInk
    }

    private var ground: Color {
        if model.noticeIsError { return ColorRole.showError.color }
        return ColorRole.showSurface.color
    }
}

#Preview { EmailAuthNotice(model: EmailAuthModel(flow: .preview())) }
