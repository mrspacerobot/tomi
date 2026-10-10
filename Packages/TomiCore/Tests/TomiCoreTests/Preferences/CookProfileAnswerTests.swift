import Testing

@testable import TomiCore

/// What a tap on a question changes in the profile the app sends to the server.
@Suite struct CookProfileAnswerTests {
    @Test func aCuisineWithoutAnAnswerCountsAsTry() {
        #expect(CookProfile().answer(for: "thai") == .try)
    }

    @Test(arguments: CuisineAnswer.allCases)
    func aCuisineSitsInExactlyOneList(answer: CuisineAnswer) {
        var profile = CookProfile()
        profile.setAnswer(.never, for: "thai")
        profile.setAnswer(.love, for: "thai")
        profile.setAnswer(answer, for: "thai")
        let lists = [profile.cuisinesLoved, profile.cuisinesToTry, profile.cuisinesNever]
        #expect(lists.filter { $0.contains("thai") }.count == 1)
        #expect(profile.answer(for: "thai") == answer)
    }

    @Test func anAvoidItemIsTickedAndUnticked() {
        var profile = CookProfile()
        profile.toggleAvoid("nuts")
        #expect(profile.avoid == ["nuts"])
        profile.toggleAvoid("nuts")
        #expect(profile.avoid.isEmpty)
    }

    @Test func aCupboardStapleIsTickedAndUnticked() {
        var profile = CookProfile()
        profile.toggleCupboardStaple("salt")
        #expect(profile.cupboardStaples == ["salt"])
        profile.toggleCupboardStaple("salt")
        #expect(profile.cupboardStaples.isEmpty)
    }

    @Test func untilAnsweredTheKitchenIsWhatTheServerAssumes() {
        #expect(CookProfile().equipment == nil)
        #expect(CookProfile().kitchen(assumedUntilAnswered: ["oven"]) == ["oven"])
    }

    @Test func theFirstTapAnswersTheKitchenFromTheAssumedOne() {
        var profile = CookProfile()
        profile.toggleEquipment("wok", assumedUntilAnswered: ["oven"])
        #expect(profile.equipment == ["oven", "wok"])
        profile.toggleEquipment("oven", assumedUntilAnswered: ["oven"])
        #expect(profile.equipment == ["wok"])
    }
}
