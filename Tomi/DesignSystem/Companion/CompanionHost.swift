import SwiftUI

/// Draws one companion at the place the current screen asked for, and keeps it alive between screens.
/// A screen without a slot leaves it invisible instead of tearing it down: RealityKit takes seconds
/// to show a companion that appears just as the last one goes away.
struct CompanionHost: View {
    let placement: CompanionPlacement?
    let identifier: String

    var body: some View {
        GeometryReader { proxy in
            ZStack { TomiCompanion(state: state) }
                .frame(width: rect(in: proxy).width, height: rect(in: proxy).height)
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier(identifier)
                .offset(x: rect(in: proxy).minX, y: rect(in: proxy).minY)
                .opacity(opacity)
        }
        .allowsHitTesting(false)
    }

    private var state: CompanionState {
        placement?.state ?? .idle
    }

    private var opacity: Double {
        guard placement != nil else { return 0 }
        return 1
    }

    private func rect(in proxy: GeometryProxy) -> CGRect {
        guard let placement else {
            return CGRect(x: 0, y: 0, width: MascotSize.companionGreeting, height: MascotSize.companionGreeting)
        }
        return proxy[placement.bounds]
    }
}

#Preview {
    CompanionHost(placement: nil, identifier: "preview-companion")
}

extension View {
    /// Draws the companion where a `CompanionSlot` inside this view asks, clipped to this view.
    func companionHost(identifier: String) -> some View {
        overlayPreferenceValue(CompanionPlacementKey.self) { placement in
            CompanionHost(placement: placement, identifier: identifier)
                .clipped()
        }
    }
}
