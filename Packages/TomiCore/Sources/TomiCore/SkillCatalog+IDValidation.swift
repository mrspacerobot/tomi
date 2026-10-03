/// Ids are typed by hand, so an empty one is an easy slip that would still decode.
extension SkillCatalog {
    var blankIDIssues: [CatalogIssue] {
        blankPositions(in: courses.map(\.id.rawValue)).map(CatalogIssue.blankCourseID)
            + blankPositions(in: skills.map(\.id.rawValue)).map(CatalogIssue.blankSkillID)
    }

    private func blankPositions(in ids: [String]) -> [Int] {
        ids.indices.filter { ids[$0].allSatisfy(\.isWhitespace) }
    }
}
