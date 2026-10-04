/// The scene kit of the design (`docs/design/src/scenes3.py`), read as text.
/// It is where a scene or a main food is drawn first, so the lists in code must match it exactly.
enum DesignKit {
    static let path = "docs/design/src/scenes3.py"

    /// The names of the scenes, in the kit's order: the first word of each entry of the `SCENES` list.
    static func sceneNames() throws -> [String] {
        let text = try Repository.text(path)
        var names: [String] = []
        for line in linesOfList(named: "SCENES = [", in: text) {
            if let name = quotedWords(in: line).first {
                names.append(name)
            }
        }
        return names
    }

    /// The names of the main foods, in the kit's order: the keys of the `MAINS` table.
    static func mainNames() throws -> [String] {
        let text = try Repository.text(path)
        for line in text.split(separator: "\n") where line.hasPrefix("MAINS = {") {
            return quotedWords(in: String(line))
        }
        return []
    }

    /// The lines after the one that opens a list, up to the line that closes it.
    private static func linesOfList(named opening: String, in text: String) -> [String] {
        let lines = text.split(separator: "\n").map(String.init)
        guard let start = lines.firstIndex(of: opening) else {
            return []
        }
        let rest = lines[(start + 1)...]
        return Array(rest.prefix { $0 != "]" })
    }

    /// The words written between double quotes in a line, in order.
    private static func quotedWords(in line: String) -> [String] {
        let pieces = line.split(separator: "\"", omittingEmptySubsequences: false)
        var words: [String] = []
        for (position, piece) in pieces.enumerated() where position % 2 == 1 {
            words.append(String(piece))
        }
        return words
    }
}
