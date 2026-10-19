import Testing

@testable import TomiCore

/// Typed items, as `POST /v1/ingredients/resolve` reads them. Only an exact match is added without asking.
@Suite struct ResolveTests {
    static let results =
        #"{"results": [{"label": "eggs", "basis": "exact", "candidates": [{"id": "egg", "name": "Egg"}]}, "#
        + #"{"label": "cheese", "basis": "ambiguous", "candidates": [{"id": "feta", "name": "Feta"}, "#
        + #"{"id": "parmesan", "name": "Parmesan"}]}, {"label": "glue", "basis": "none", "candidates": []}]}"#

    @Test func everyResultIsReadInOrder() throws {
        let response = try ServerJSON.decode(ResolveResponse.self, from: Self.results)
        #expect(response.results.map(\.basis) == [.exact, .ambiguous, .noMatch])
        #expect(response.results.map(\.label) == ["eggs", "cheese", "glue"])
    }

    @Test func anExactMatchGivesItsIngredient() throws {
        let response = try ServerJSON.decode(ResolveResponse.self, from: Self.results)
        #expect(response.results[0].exactIngredient == NamedOption(id: "egg", name: "Egg"))
    }

    @Test func anAmbiguousOrMissingMatchGivesNoIngredientOfItsOwn() throws {
        let response = try ServerJSON.decode(ResolveResponse.self, from: Self.results)
        #expect(response.results[1].exactIngredient == nil)
        #expect(response.results[2].exactIngredient == nil)
    }

    @Test func anExactMatchWithSeveralCandidatesIsAskedAbout() {
        let candidates = [NamedOption(id: "feta", name: "Feta"), NamedOption(id: "brie", name: "Brie")]
        #expect(ResolvedLabel(label: "cheese", basis: .exact, candidates: candidates).exactIngredient == nil)
    }
}
