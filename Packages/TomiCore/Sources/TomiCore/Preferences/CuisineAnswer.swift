/// How the cook feels about one cuisine. The server keeps one list per answer
/// (`cuisinesLoved`, `cuisinesToTry`, `cuisinesNever`); a cuisine in none of them counts as "try".
public enum CuisineAnswer: CaseIterable, Hashable, Sendable {
    case love
    case `try`
    case never
}
