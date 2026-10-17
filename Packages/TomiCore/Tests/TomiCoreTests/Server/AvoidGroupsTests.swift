import Testing

@testable import TomiCore

/// How the avoid question groups what the server lists, and which saved ids it cannot name.
@Suite struct AvoidGroupsTests {
    private var options: LibraryOptions {
        var options = LibraryOptions()
        options.avoidItems = [
            AvoidOption(id: "pork", name: "Pork", kind: .choice),
            AvoidOption(id: "nuts", name: "Nuts", kind: .allergen),
            AvoidOption(id: "alcohol", name: "Alcohol", kind: .choice),
            AvoidOption(id: "celery", name: "Celery", kind: .allergen),
        ]
        return options
    }

    @Test func eachGroupKeepsTheOrderTheServerSends() {
        #expect(options.avoidItems(of: .allergen).map(\.id) == ["nuts", "celery"])
        #expect(options.avoidItems(of: .choice).map(\.id) == ["pork", "alcohol"])
    }

    @Test func aSavedIdTheServerDoesNotListCannotBeNamed() {
        let saved: Set<OptionID> = ["nuts", "zeta", "alpha"]
        #expect(options.unlistedAvoidIDs(in: saved) == ["alpha", "zeta"])
    }

    @Test func nothingIsUnlistedWhenEverySavedIdIsListed() {
        #expect(options.unlistedAvoidIDs(in: ["nuts", "pork"]).isEmpty)
    }
}
