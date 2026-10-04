/// No Swift file may name a specific skill, ingredient, diet or any other id of the library.
/// Content is data: code that says `"sear"` works for one menu and breaks when the library changes.
struct ContentIDRule {
    /// Every id the library uses.
    let ids: Set<String>

    /// One line for every place a source file holds a library id as a string literal.
    func violations(in files: [SourceFile]) -> [String] {
        var violations: [String] = []
        for file in files {
            for id in ids.sorted() where file.namesLiteral(id) {
                violations.append("\(file.path) names \"\(id)\"")
            }
        }
        return violations
    }
}
