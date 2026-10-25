/// Whether a graph identity segment uses the graph's ASCII slug alphabet.
func isValidTeachingSlug(_ slug: Substring) -> Bool {
    guard !slug.isEmpty, slug.count <= 64, slug.first != "-", slug.last != "-" else { return false }
    let pieces = slug.split(separator: "-", omittingEmptySubsequences: false)
    return pieces.allSatisfy { part in
        !part.isEmpty
            && part.unicodeScalars.allSatisfy { scalar in
                (97...122).contains(scalar.value) || (48...57).contains(scalar.value)
            }
    }
}

/// Whether a quiz ID has the exact technique and quiz path with nonempty slug segments.
func isValidTeachingQuestionID(_ identifier: String) -> Bool {
    let pieces = identifier.split(separator: "/", omittingEmptySubsequences: false)
    guard pieces.count == 4, pieces[0] == "technique", pieces[2] == "quiz" else { return false }
    return isValidTeachingSlug(pieces[1]) && isValidTeachingSlug(pieces[3])
}
