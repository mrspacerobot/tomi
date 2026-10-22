import Foundation
import Testing

@testable import TomiCore

/// An avoid item as `GET /v1/options` sends it: an id, a name and the kind that decides its group.
@Suite struct AvoidOptionTests {
    private func decode(_ json: String) throws -> AvoidOption {
        try JSONDecoder().decode(AvoidOption.self, from: Data(json.utf8))
    }

    @Test func anAllergenIsRead() throws {
        let item = try decode(#"{"id": "celery", "name": "Celery", "kind": "allergen"}"#)
        #expect(item == AvoidOption(id: "celery", name: "Celery", kind: .allergen))
    }

    @Test func aChoiceIsRead() throws {
        let item = try decode(#"{"id": "pork", "name": "Pork", "kind": "choice"}"#)
        #expect(item.kind == .choice)
    }

    @Test func aMissingKindIsReadAsAnAllergen() throws {
        let item = try decode(#"{"id": "nuts", "name": "Nuts"}"#)
        #expect(item.kind == .allergen)
    }

    @Test func anUnknownKindIsReadAsAnAllergen() throws {
        let item = try decode(#"{"id": "nuts", "name": "Nuts", "kind": "from-the-future"}"#)
        #expect(item.kind == .allergen)
    }

    @Test func aNumberAsKindIsReadAsAnAllergen() throws {
        let item = try decode(#"{"id": "nuts", "name": "Nuts", "kind": 7}"#)
        #expect(item.kind == .allergen)
    }

    @Test func theKindIsSentBackAsTheServerWritesIt() throws {
        let data = try JSONEncoder().encode(AvoidOption(id: "pork", name: "Pork", kind: .choice))
        let json = try #require(String(bytes: data, encoding: .utf8))
        #expect(json.contains(#""kind":"choice""#))
    }
}
