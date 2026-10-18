import Testing

@testable import Tomi

/// What makes each state recognisable when it is still, as the design describes it.
struct CompanionExpressionTests {
    @Test func idleWavesWithItsRightHandRaised() {
        let arm = CompanionState.idle.stillPose.rightArm
        #expect(arm.hand.y < arm.shoulder.y - 30)
    }

    @Test func listeningLeansInWithAHandCuppedBesideTheFace() {
        let pose = CompanionState.listening.stillPose
        #expect(pose.body.tilt < 0)
        #expect(pose.leftArm.hand.y < pose.leftArm.shoulder.y)
        #expect(pose.face.eyes.openness > 1)
        #expect(pose.face.leftBrow.lift < 0)
        #expect(pose.face.rightBrow.lift < 0)
    }

    @Test func thinkingGlancesUpWithOneBrowRaisedAndAHandAtTheChin() {
        let pose = CompanionState.thinking.stillPose
        #expect(pose.face.eyes.look.y < 0)
        #expect(pose.face.leftBrow.lift < pose.face.rightBrow.lift)
        #expect(pose.face.mouth.shape == .hmm)
        #expect(pose.rightArm.hand.x < pose.rightArm.shoulder.x - 20)
        #expect(pose.extras.thought.third > pose.extras.thought.first)
    }

    @Test func explainingOpensBothHandsAndSpeaks() {
        let pose = CompanionState.explaining.stillPose
        #expect(pose.leftArm.hand.x < pose.leftArm.shoulder.x - 15)
        #expect(pose.rightArm.hand.x > pose.rightArm.shoulder.x + 15)
        #expect(pose.face.mouth.open > CompanionState.idle.stillPose.face.mouth.open)
    }

    @Test func explainingCyclesMouthShapesWhileSpeaking() {
        let mouths = stride(from: 0.0, to: 1.0, by: 0.05).map { elapsed in
            CompanionMotion.pose(state: .explaining, elapsed: elapsed, moving: true).face.mouth
        }
        #expect(Set(mouths.map(\.shape)).count >= 2)
        #expect(Set(mouths.map(\.open)).count >= 4)
    }

    @Test func celebratingThrowsBothArmsUpWithHappyEyesAndAnOpenMouth() {
        let pose = CompanionState.celebrating.stillPose
        #expect(pose.leftArm.hand.y < pose.leftArm.shoulder.y - 30)
        #expect(pose.rightArm.hand.y < pose.rightArm.shoulder.y - 30)
        #expect(pose.face.eyes.happy)
        #expect(pose.face.mouth.open > CompanionState.explaining.stillPose.face.mouth.open)
        #expect(pose.extras.sparkle > 0)
    }

    @Test(arguments: [CompanionState.idle, .listening, .explaining, .celebrating])
    func onlyThinkingShowsThoughtDots(state: CompanionState) {
        #expect(state.stillPose.extras.thought == .hidden)
    }
}
