@testable import TomiCore

extension LibraryLists {
    /// The fixture catalog, the fixture ingredient table and the fixture equipment list.
    static func fixture() -> LibraryLists {
        LibraryLists(catalog: .fixture(), ingredientTable: .fixture(), equipmentList: .fixture())
    }
}
