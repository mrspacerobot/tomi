import Testing

@testable import Tomi

@MainActor
@Suite struct VoiceTryoutModelTests {
    let speaker = FakeSpeaker()

    @Test func aTypedLineIsSpokenAndRemembered() async {
        let model = VoiceTryoutModel(speaker: speaker)
        model.draft = "Heat the pan."
        await model.speak()
        #expect(speaker.spoken == ["Heat the pan."])
        #expect(model.said == ["Heat the pan."])
        #expect(model.draft.isEmpty)
    }

    @Test(arguments: ["", "   ", "\n"])
    func nothingTypedSpeaksNothing(draft: String) async {
        let model = VoiceTryoutModel(speaker: speaker)
        model.draft = draft
        await model.speak()
        #expect(speaker.spoken.isEmpty)
        #expect(model.said.isEmpty)
    }

    @Test func aRememberedLineCanBeSaidAgain() async {
        let model = VoiceTryoutModel(speaker: speaker)
        await model.say("Stir.")
        await model.say("Stir.")
        #expect(speaker.spoken == ["Stir.", "Stir."])
        #expect(model.said == ["Stir."])
    }

    @Test func aSpeakerThatFailsIsReportedAndNothingIsRemembered() async {
        speaker.failure = SpeakerError.unavailable
        let model = VoiceTryoutModel(speaker: speaker)
        await model.say("Heat the pan.")
        #expect(model.didFail)
        #expect(model.said.isEmpty)
    }

    @Test func theNextLineClearsTheFailure() async {
        speaker.failure = SpeakerError.unavailable
        let model = VoiceTryoutModel(speaker: speaker)
        await model.say("One.")
        speaker.failure = nil
        await model.say("Two.")
        #expect(!model.didFail)
    }

    @Test func anInterruptedLineDoesNotEndTheSpeakingOfTheLineThatReplacedIt() async {
        let model = VoiceTryoutModel(speaker: speaker)
        let (first, second) = await sayTwoLinesAtOnce(with: model)
        speaker.finishOldestLine()
        await first.value
        #expect(model.isSpeaking)
        speaker.finishOldestLine()
        await second.value
        #expect(!model.isSpeaking)
    }

    private func sayTwoLinesAtOnce(with model: VoiceTryoutModel) async -> (Task<Void, Never>, Task<Void, Never>) {
        speaker.holdsLines = true
        let first = Task { await model.say("One.") }
        let second = Task { await model.say("Two.") }
        while speaker.heldLineCount < 2 {
            await Task.yield()
        }
        return (first, second)
    }

    @Test func stoppingStopsTheSpeaker() {
        let model = VoiceTryoutModel(speaker: speaker)
        model.stop()
        #expect(speaker.stopCount == 1)
    }
}
