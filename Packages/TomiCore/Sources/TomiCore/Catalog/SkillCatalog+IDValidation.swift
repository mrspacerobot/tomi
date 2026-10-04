/// Ids are typed by hand, so an empty one is an easy slip that would still decode.
extension SkillCatalog {
    var blankIDIssues: [CatalogIssue] {
        courses.map(\.id.rawValue).blankPositions.map(CatalogIssue.blankCourseID)
            + skills.map(\.id.rawValue).blankPositions.map(CatalogIssue.blankSkillID)
    }
}
