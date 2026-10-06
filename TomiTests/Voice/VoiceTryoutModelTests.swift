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

    @Test func stoppingStopsTheSpeaker() {
        let model = VoiceTryoutModel(speaker: speaker)
        model.stop()
        #expect(speaker.stopCount == 1)
    }
}
