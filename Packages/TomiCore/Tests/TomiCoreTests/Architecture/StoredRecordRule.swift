/// Saved data must stay safe for iCloud: every stored property optional or defaulted and nothing unique.
/// Stored field names are permanent, so each one is also written down in the plan.
/// The rule reads the SwiftData records of the app as text, because the rules package cannot import them.
enum StoredRecordRule {
    /// The files that declare a stored record.
    static func records(in files: [SourceFile]) -> [SourceFile] {
        files.filter { $0.codeLines.contains("@Model") }
    }

    /// One line for every stored property that is neither optional nor defaulted, and for every unique constraint.
    static func violations(in files: [SourceFile]) -> [String] {
        var violations: [String] = []
        for file in records(in: files) {
            for line in storedProperties(of: file) where !isOptionalOrDefaulted(line) {
                violations.append("\(file.path) stores \"\(line)\", which is neither optional nor defaulted")
            }
            for line in file.codeLines where isUniqueConstraint(line) {
                violations.append("\(file.path) declares \"\(line)\", and nothing stored may be unique")
            }
        }
        return violations
    }

    /// The stored field names of every record that the document does not list in code type, such as `diet`.
    static func fields(of files: [SourceFile], missingFrom document: String) -> [String] {
        var missing: [String] = []
        for file in records(in: files) {
            for name in fieldNames(of: file) where !document.contains("`" + name + "`") {
                missing.append(name)
            }
        }
        return missing
    }

    static func fieldNames(of file: SourceFile) -> [String] {
        var names: [String] = []
        for line in storedProperties(of: file) {
            let declaration = line.dropFirst("var ".count)
            names.append(String(declaration.prefix { $0 != ":" && $0 != " " }))
        }
        return names
    }

    private static func storedProperties(of file: SourceFile) -> [String] {
        file.codeLines.filter { $0.hasPrefix("var ") }
    }

    private static func isOptionalOrDefaulted(_ line: String) -> Bool {
        line.hasSuffix("?") || line.contains(" = ")
    }

    private static func isUniqueConstraint(_ line: String) -> Bool {
        line.contains(".unique") || line.contains("#Unique")
    }
}
