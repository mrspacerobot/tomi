/// The quiz of the backend's teaching example, as the app must read it.
enum TeachingQuizExample {
    static let ids = [
        "technique/scramble/quiz/purpose",
        "technique/scramble/quiz/method",
        "technique/scramble/quiz/observation",
        "technique/scramble/quiz/correction",
    ]

    static let questions = [
        "Which texture is the aim of this scramble method?",
        "How do you stir the eggs for this gentle scramble?",
        "Which spoon trail matches the texture described here?",
        "The curds are forming too fast. What would you do?",
    ]

    static let choices = [
        ["Small, soft, creamy curds.", "Large, dry, rubbery curds.", "A firm sheet for rolling."],
        [
            "Only across the surface, leaving the base untouched.",
            "Continuously, scraping the bottom and corners.",
            "Only after a browned layer has formed.",
        ],
        ["A dry gap that never closes.", "No trail in a completely watery mixture.", "A trail that closes slowly."],
        [
            "Lift the pan off the heat and keep stirring.",
            "Keep the pan on the heat and stir faster.",
            "Reduce stirring so the curds have time to join together.",
        ],
    ]
}
