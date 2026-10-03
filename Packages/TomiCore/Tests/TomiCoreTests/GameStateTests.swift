import Foundation
import Testing

@testable import TomiCore

/// The game state is the one answer screens ask for: XP, rank and streak from the same log at the same moment.
@Suite struct GameStateTests {
    let test = StreakTestCalendar()
    let xpWithQuiz = GameRules.xpPerCook + GameRules.xpForCorrectQuiz

    func state(_ entries: [CookEntry], goal: Int = 2, on day: DateComponents) -> GameState {
        GameStateRules(calendar: test.calendar).gameState(for: entries, goal: goal, now: test.date(day))
    }

    @Test func aNewCookStartsWithNoXPAsANoviceWithNoStreak() {
        let state = state([], on: .october(6))
        #expect(state.xp == 0)
        #expect(state.rank == Rank.forXP(0))
        #expect(state.streak.weeks == 0)
        #expect(state.streak.daysThisWeek == 0)
    }

    @Test func xpRankAndStreakComeFromTheSameLog() {
        let lastWeek: [CookEntry] = [.fixture("knife", on: .september(28)), .fixture("eggs", on: .october(2))]
        let thisWeek: [CookEntry] = [.fixture("knife", on: .october(5))]
        let state = state(lastWeek + thisWeek, on: .october(6))
        #expect(state.xp == 3 * xpWithQuiz)
        #expect(state.rank == Rank.forXP(3 * xpWithQuiz))
        #expect(state.streak.weeks == 1)
        #expect(state.streak.daysThisWeek == 1)
    }

    @Test func theStreakIsTheOneTheStreakRulesGiveForTheLog() {
        let log: [CookEntry] = [.fixture("knife", on: .september(28)), .fixture("eggs", on: .october(5))]
        let state = state(log, goal: 4, on: .october(6))
        #expect(state.streak == test.streak(log.completedCooks, goal: 4, on: .october(6)))
    }

    @Test func stoppedEarlyAndRepeatedEntriesChangeNothing() {
        let cook = CookEntry.fixture("knife", on: .october(5))
        let abandoned = CookEntry.fixture("eggs", on: .october(6)).stoppedBeforeTheEnd()
        #expect(state([cook, abandoned, cook], on: .october(6)) == state([cook], on: .october(6)))
    }

    @Test func enoughCooksRaiseTheRank() {
        let commisAt = GameRules.rankThresholds[1]
        let cooksNeeded = (commisAt - 1) / xpWithQuiz + 1
        let state = state(ProgressTestLog().cooks(cooksNeeded, of: "knife"), on: .october(6))
        #expect(state.rank.title == .commis)
        #expect(state.rank.xp == state.xp)
    }
}
