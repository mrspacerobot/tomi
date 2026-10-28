import Foundation

/// XP, rank, streak, levels, unlocks, mastery, grants and focus are worked out by Tomi's server alone, so the rules
/// package keeps no game folder and declares no type of rules for them. Read as text, like the other rules.
enum ServerGameRule {
    /// The folder the game rules lived in until the server took them over.
    static let removedFolder = "Game"

    /// Every rule type the game had was named `...Rules`, and the rules package has no other.
    static let ruleTypeSuffix = "Rules"

    private static let declarationKinds = ["struct", "enum", "class", "actor", "protocol", "typealias", "extension"]

    /// One line for every declaration of a rules type in these files.
    static func violations(_ files: [SourceFile]) -> [String] {
        var violations: [String] = []
        for file in files {
            for name in declaredNames(in: file) where name.hasSuffix(ruleTypeSuffix) {
                violations.append("\(file.path) declares \(name)")
            }
        }
        return violations
    }

    /// The names after a declaration keyword, such as `CookOutbox` in `public struct CookOutbox: Sendable {`.
    static func declaredNames(in file: SourceFile) -> [String] {
        var names: [String] = []
        for line in file.codeLines {
            let words = line.split(whereSeparator: { !$0.isLetter && !$0.isNumber && $0 != "_" }).map(String.init)
            for (index, word) in words.enumerated() where declarationKinds.contains(word) && index + 1 < words.count {
                names.append(words[index + 1])
            }
        }
        return names
    }
}
