import TomiCore

/// The server for quiz previews: the fake without a quiz, so a preview shows questions and never knows an answer.
enum CookingQuizPreviewAPI {
    static var unanswered: any TomiAPI {
        FakeTomiAPI()
    }
}
