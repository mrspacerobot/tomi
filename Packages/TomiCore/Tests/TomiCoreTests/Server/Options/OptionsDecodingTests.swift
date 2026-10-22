import Testing

@testable import TomiCore

/// The lists onboarding and settings are built from, as `GET /v1/options` sends them.
@Suite struct OptionsDecodingTests {
    @Test func everyListIsRead() throws {
        let options = try ServerJSON.decode(LibraryOptions.self, from: ServerJSON.options)
        #expect(options.libraryVersion == 3)
        #expect(options.diets == [DescribedOption(id: "vegan", name: "Vegan", summary: "No animals")])
        #expect(options.avoidItems == [AvoidOption(id: "nuts", name: "Nuts", kind: .allergen)])
        #expect(options.cuisines.map(\.id) == ["thai"])
        #expect(options.experience.map(\.id) == ["basics"])
        #expect(options.units.map(\.id) == ["metric"])
        #expect(options.staples == [StapleOption(id: "salt", name: "Salt", assumed: true)])
        #expect(options.ingredients.map(\.name) == ["Salt"])
        #expect(options.courses.first?.skills.first?.levels == [NamedLevel(number: 1, name: "Soft")])
    }

    @Test func theAssumedKitchenIsWhatTheServerMarksAsAssumed() throws {
        let options = try ServerJSON.decode(LibraryOptions.self, from: ServerJSON.options)
        #expect(options.assumedEquipment == ["oven"])
    }

    @Test func aListMissingFromTheAnswerRefusesIt() {
        #expect(throws: DecodingError.self) {
            try ServerJSON.decode(LibraryOptions.self, from: #"{"libraryVersion": 3, "diets": []}"#)
        }
    }
}
