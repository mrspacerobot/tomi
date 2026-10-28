import Foundation

/// Cuts a line Tomi will say into sentences, so the first can be spoken while the next is still being made.
public enum SpokenSentences {
    /// A sentence ends at a full stop, "!", "?" or "…" followed by white space or the end, so "2.5" stays whole.
    /// A computed property, because a stored regular expression is not safe to share between threads.
    private static var sentence: Regex<Substring> {
        /[\s\S]+?(?:[.!?…]+(?=\s)|$)/
    }

    public static func split(_ line: String) -> [String] {
        let matches = line.matches(of: sentence)
        let trimmed = matches.map { $0.output.trimmingCharacters(in: .whitespacesAndNewlines) }
        return trimmed.filter { !$0.isEmpty }
    }
}
