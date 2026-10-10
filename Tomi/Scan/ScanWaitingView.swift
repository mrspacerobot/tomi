import SwiftUI

/// While Tomi checks, reads the photo or looks for tonight's special.
struct ScanWaitingView: View {
    let stage: ScanStage

    var body: some View {
        VStack(spacing: Spacing.medium) {
            ProgressView()
            Text(words)
                .textStyle(.description)
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("scan-waiting")
    }

    private var words: LocalizedStringResource {
        switch stage {
        case .reading: .scanReading
        case .finding: .scanFinding
        default: .scanChecking
        }
    }
}

#Preview {
    ScanWaitingView(stage: .reading)
}
