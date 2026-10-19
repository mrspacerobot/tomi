import Foundation
import TomiCore

/// How long a step of the graph's recipe takes, written with Foundation's duration formatter.
nonisolated enum SourceTimeFormat {
    private static let style = Duration.UnitsFormatStyle(
        allowedUnits: [.hours, .minutes, .seconds],
        width: .abbreviated
    )

    static func text(for time: SourceTime) -> String? {
        guard let shortest = time.shortestDuration, let longest = time.longestDuration else {
            return nil
        }
        if shortest == longest {
            return shortest.formatted(style)
        }
        return String(localized: .offerStepTimeRange(shortest.formatted(style), longest.formatted(style)))
    }
}
