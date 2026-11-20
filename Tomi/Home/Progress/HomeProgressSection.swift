import SwiftUI
import TomiCore

/// The server's progress under the masthead, and under it the kind note when it may be behind.
/// Before the first snapshot only the note can show: never a column of zeros.
struct HomeProgressSection: View {
    let shown: ShownProgress

    var body: some View {
        VStack(spacing: Spacing.small) {
            if let note = shown.note {
                HomeProgressNote(note: note)
            }
            if let snapshot = shown.snapshot {
                HomeProgressStrip(snapshot: snapshot, showsThisWeek: shown.showsThisWeek)
            }
        }
    }
}

#Preview("Offline with unsent cooks") {
    if let shown = ShownProgress.previewOffline() {
        HomeProgressSection(shown: shown)
            .padding()
            .background(ColorRole.paper.color)
    }
}

#Preview("No snapshot yet, largest text") {
    HomeProgressSection(shown: .previewWithoutSnapshot())
        .padding()
        .background(ColorRole.paper.color)
        .dynamicTypeSize(.accessibility5)
}
