#if DEBUG
    import SwiftUI
    import TomiCore

    /// A list of tick rows under the cobalt rule that opens it. Which rows are ticked comes from the
    /// selection it is given; a tap is passed on by the number of the row.
    struct GalleryTickRows: View {
        let samples: [TickRowSample]
        let selection: Selection<Int>
        /// What UI tests find the rows by, followed by the number of the row.
        let identifier: String
        let onTap: (Int) -> Void

        var body: some View {
            VStack(spacing: ShowSize.gap) {
                ForEach(Array(samples.enumerated()), id: \.offset) { index, sample in
                    let choice = TickChoice(optionID: nil, name: sample.name, note: sample.note)
                    ShowQuestionChoice(choice: choice, selected: selection.isSelected(index)) {
                        onTap(index)
                    }
                    .accessibilityIdentifier("\(identifier)-\(index)")
                }
            }
        }
    }

    #Preview {
        GalleryTickRows(
            samples: TickRowSample.equipment,
            selection: Selection(mode: .multiple),
            identifier: "preview",
            onTap: { _ in }
        )
        .background { ShowStage() }
    }
#endif
