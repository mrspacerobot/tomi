import Testing

@testable import TomiCore

/// What a list of tick rows holds after each tap, for a question with one answer and one with several.
@Suite struct SelectionTests {
    @Test func aNewSelectionHoldsNothing() {
        #expect(Selection<Int>(mode: .single).selected.isEmpty)
        #expect(Selection<Int>(mode: .multiple).selected.isEmpty)
    }

    @Test func aSingleSelectionKeepsOnlyTheLastOptionTapped() {
        var selection = Selection<Int>(mode: .single)

        selection.tap(1)
        selection.tap(2)

        #expect(selection.selected == [2])
        #expect(selection.isSelected(2))
        #expect(!selection.isSelected(1))
    }

    /// One answer is required once given: a second tap on it must not leave the question unanswered.
    @Test func tappingTheSelectedOptionOfASingleSelectionKeepsIt() {
        var selection = Selection<Int>(mode: .single)

        selection.tap(1)
        selection.tap(1)

        #expect(selection.selected == [1])
    }

    @Test func aMultipleSelectionKeepsEveryOptionTapped() {
        var selection = Selection<Int>(mode: .multiple)

        selection.tap(1)
        selection.tap(2)

        #expect(selection.selected == [1, 2])
    }

    @Test func tappingASelectedOptionOfAMultipleSelectionRemovesIt() {
        var selection = Selection<Int>(mode: .multiple)

        selection.tap(1)
        selection.tap(2)
        selection.tap(1)

        #expect(selection.selected == [2])
        #expect(!selection.isSelected(1))
    }
}
