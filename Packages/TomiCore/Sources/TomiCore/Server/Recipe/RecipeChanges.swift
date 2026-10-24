/// What the server changed from the graph's own recipe for this cook. Both lists are required: a missing list
/// must never read as "nothing changed".
public struct RecipeChanges: Hashable, Decodable, Sendable {
    public let swaps: [SuggestionSwap]
    public let leftOut: [LeftOutPart]
}
