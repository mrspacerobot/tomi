import SwiftUI

struct FridgeScanLine: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var down = false

    var body: some View {
        ColorRole.showGold.color
            .frame(height: RuleWeight.showRing)
            .frame(maxHeight: .infinity, alignment: alignment)
            .padding(.vertical, ShowSize.rowGap)
            .animation(sweep, value: down)
            .onAppear { down = true }
            .accessibilityHidden(true)
    }

    private var alignment: Alignment {
        if reduceMotion || scenePhase != .active { return .center }
        if down { return .bottom }
        return .top
    }

    private var sweep: Animation? {
        guard !reduceMotion, scenePhase == .active else { return nil }
        return .easeInOut(duration: FridgeMonitorSize.sweep / 2).repeatForever(autoreverses: true)
    }
}

#Preview {
    if let photo = JPEGConverter.preview(from: PhotoSource.fakePhoto) {
        FridgeMonitor(photo: photo, isReading: true)
    }
}
