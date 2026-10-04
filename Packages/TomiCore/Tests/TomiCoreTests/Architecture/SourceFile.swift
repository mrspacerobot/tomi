/// One Swift file of the repository, as the architecture rules read it.
struct SourceFile {
    /// The path from the repository root, such as `Tomi/Home/HomeView.swift`.
    let path: String
    let text: String

    /// The lines that are code. Comment lines are left out, so a rule never trips over an explanation.
    var codeLines: [String] {
        var code: [String] = []
        for line in text.split(separator: "\n") {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if !trimmed.hasPrefix("//") {
                code.append(trimmed)
            }
        }
        return code
    }

    /// The modules the file imports, such as `Foundation`.
    var imports: [String] {
        var modules: [String] = []
        for line in codeLines where line.hasPrefix("import ") {
            modules.append(String(line.dropFirst("import ".count)))
        }
        return modules
    }

    /// Whether the code holds this exact word as a string literal, such as `"sear"`.
    func namesLiteral(_ word: String) -> Bool {
        let literal = "\"" + word + "\""
        return codeLines.contains { $0.contains(literal) }
    }
}
