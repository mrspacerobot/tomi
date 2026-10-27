import Foundation
import Testing

@testable import TomiCore

/// Cooking a suggestion writes a cook the server can take: the graph recipe, the graph version it came from, and the
/// entry id the quiz picks were recorded under.
@Suite struct SuggestionCookTests {
    let id = UUID(uuidString: "4E2C2A0E-7E6B-4C7A-9C2B-6E0A3D1F9A11")!
    let moment = CookSession(date: TestCalendar().date(.october(5)), result: .finished(quizCorrect: false), weeklyGoal: 3)

    func response(_ graphVersion: String?) throws -> Suggestion {
        var named = ""
        if let graphVersion {
            named = "\"graphVersion\": \"\(graphVersion)\", "
        }
        let text = #"{"# + named + #""rankedBy": "model", "special": "# + GraphJSON.suggestion() + #", "alternatives": []}"#
        let special = try ServerJSON.decode(SuggestionsResponse.self, from: text).special
        return try #require(special)
    }

    @Test func theEntryNamesTheRecipeTheSkillAndTheGraphVersion() throws {
        let entry = try response("2026.10.20").cooked(id: id, session: moment, account: "cook-a")
        #expect(entry.id == id)
        #expect(entry.lesson.id.rawValue == "recipe/soft-scrambled-eggs")
        #expect(entry.lesson.graphVersion == "2026.10.20")
        #expect(entry.account == "cook-a")
        #expect(entry.isSendable)
    }

    @Test func theGraphVersionOfTheWholeAnswerIsTheOneCooked() throws {
        #expect(try response("2026.10.20").graphVersion == "2026.10.20")
    }

    @Test func aSuggestionFromNoGraphVersionIsKeptAndNeverSent() throws {
        let suggestion = try response(nil)
        let entry = suggestion.cooked(id: id, session: moment, account: "cook-a")
        #expect(suggestion.graphVersion == nil)
        #expect(!entry.isSendable)
    }
}
