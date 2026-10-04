import Testing

@testable import TomiCore

/// XP is counted from the cook log, with the numbers of `GameRules` and nothing stored beside the log.
@Suite struct CookLogXPTests {
    let xpWithQuiz = GameRules.xpPerCook + GameRules.xpForCorrectQuiz

    @Test func anEmptyLogHasNoXP() {
        let log: [CookEntry] = []
        #expect(log.earnedXP == 0)
    }

    @Test func aFinishedCookWithTheQuizRightEarnsTheCookAndTheQuiz() {
        #expect([CookEntry.fixture("knife")].earnedXP == xpWithQuiz)
    }

    @Test func aFinishedCookWithTheQuizWrongEarnsTheCookOnly() {
        let entry = CookEntry.fixture("knife").withTheQuizWrong()
        #expect([entry].earnedXP == GameRules.xpPerCook)
    }

    @Test func anEntryStoppedEarlyEarnsNothingEvenWithTheQuizRight() {
        let entry = CookEntry.fixture("knife").stoppedBeforeTheEnd()
        #expect([entry].earnedXP == 0)
    }

    @Test func theSameEntryTwiceAfterAMergeEarnsOnce() {
        let entry = CookEntry.fixture("knife")
        let other = CookEntry.fixture("eggs").withTheQuizWrong()
        let merged = [entry, other] + [other, entry]
        #expect(merged.earnedXP == xpWithQuiz + GameRules.xpPerCook)
    }

    @Test func anEntryTheCatalogDoesNotKnowStillEarnsXP() {
        #expect([CookEntry.fixture("sous-vide", level: 9)].earnedXP == xpWithQuiz)
    }

    @Test func everyFinishedCookAddsUp() {
        let log = ProgressTestLog().cooks(3, of: "knife") + ProgressTestLog().cooks(2, of: "eggs", level: 2)
        #expect(log.earnedXP == 5 * xpWithQuiz)
    }

    @Test func theCookThatReachesAThresholdCrossesIntoTheNextRank() {
        let commisAt = GameRules.rankThresholds[1]
        let cooksStillBelow = (commisAt - 1) / xpWithQuiz
        let below = ProgressTestLog().cooks(cooksStillBelow, of: "knife")
        let across = below + [CookEntry.fixture("knife")]
        #expect(Rank.forXP(below.earnedXP).title == .novice)
        #expect(Rank.forXP(across.earnedXP).title == .commis)
    }
}
