extension Array where Element == HomeRoute {
    mutating func returnToSuggestion() {
        while let last, !last.isSuggestion {
            removeLast()
        }
    }
}
