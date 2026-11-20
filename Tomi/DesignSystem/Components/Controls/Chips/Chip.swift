import SwiftUI

/// An ingredient as a chip. The chip only shows the state it is given and reports the tap: what the tap
/// changes (on to off, out for tonight, off the list) is decided outside the view. A locked chip is not a
/// button and ignores its action. VoiceOver reads the name and then the state in words.
struct Chip: View {
    let name: String
    let kind: ChipKind
    var action: () -> Void = {}

    var body: some View {
        if kind == .locked {
            ChipFace(name: name, kind: kind)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(kind.label(for: name))
                .accessibilityValue(kind.value)
        } else {
            Button(action: action) {
                ChipFace(name: name, kind: kind)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(kind.label(for: name))
            .accessibilityValue(kind.value)
            .accessibilitySelected(kind == .on)
        }
    }
}

#Preview("Light") {
    FlowLayout {
        Chip(name: String(localized: .sampleChipLocked), kind: .locked)
        Chip(name: String(localized: .sampleChipOn), kind: .on)
        Chip(name: String(localized: .sampleChipOff), kind: .off)
        Chip(name: String(localized: .sampleChipTonight), kind: .offTonight)
        Chip(name: String(localized: .sampleChipRemovable), kind: .removable)
        Chip(name: String(localized: .sampleChipUnsure), kind: .unsure)
    }
    .padding()
    .background { ShowStage() }
}

#Preview("Dark, largest text") {
    FlowLayout {
        ForEach(ChipKind.allCases, id: \.self) { kind in
            Chip(name: String(localized: .sampleChipTonight), kind: kind)
        }
    }
    .padding()
    .background { ShowStage() }
    .preferredColorScheme(.dark)
    .dynamicTypeSize(.accessibility5)
}
