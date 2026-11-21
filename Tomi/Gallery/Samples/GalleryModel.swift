#if DEBUG
    import Observation
    import TomiCore

    /// What the gallery remembers between taps, so every component can be tried: the views only show it.
    @Observable final class GalleryModel {
        static let totalSteps = 6

        private(set) var taps = 0
        private(set) var diet = Selection<Int>(mode: .single)
        private(set) var equipment = Selection<Int>(mode: .multiple)
        private(set) var completedSteps = 2
        private var chipsOn = Selection<GalleryChip>(mode: .multiple)
        private var chipsRemoved = Selection<GalleryChip>(mode: .multiple)

        /// The gallery opens the way the handoff draws it: the first of several answers ticked, and of the
        /// chips one staple on and the others off.
        init() {
            equipment.tap(0)
            chipsOn.tap(.staple)
        }

        var shownChips: [GalleryChip] {
            GalleryChip.allCases.filter { !chipsRemoved.isSelected($0) }
        }

        func kind(of chip: GalleryChip) -> ChipKind {
            if let offKind = chip.offKind, !chipsOn.isSelected(chip) {
                return offKind
            }
            return chip.kind
        }

        func countTap() {
            taps += 1
        }

        func tapDiet(_ index: Int) {
            diet.tap(index)
        }

        func tapEquipment(_ index: Int) {
            equipment.tap(index)
        }

        /// A chip with a cross leaves the list; any other is switched on or off.
        func tap(_ chip: GalleryChip) {
            if chip.kind.isRemovable {
                chipsRemoved.tap(chip)
            } else {
                chipsOn.tap(chip)
            }
        }

        /// One step on, and back to none after the last, so the rule can be seen empty and full.
        func nextStep() {
            completedSteps = (completedSteps + 1) % (Self.totalSteps + 1)
        }
    }
#endif
