import Foundation
import Testing

@testable import TomiCore

@Suite struct CatalogDecodingTests {
    @Test func aValidCatalogDecodes() throws {
        let catalog = try SkillCatalog.decode(
            from: json(
                skills: #"[{"id": "knife", "course": "basics", "#
                    + #""name": {"en": "Knife"}, "summary": {"en": "Cuts"}, "prerequisites": [], "#
                    + #""levels": [{"number": 1, "name": {"en": "Mirepoix"}}]}]"#
            )
        )
        #expect(catalog.skills.map(\.id) == ["knife"])
        #expect(catalog.skill("knife")?.levels.first?.name.resolved(preferredLanguages: []) == "Mirepoix")
    }

    @Test func anUnknownSchemaVersionIsRejectedBeforeReadingTheRest() {
        #expect(throws: CatalogError.unsupportedSchemaVersion(99)) {
            try SkillCatalog.decode(from: json(schemaVersion: 99, skills: #""a shape from the future""#))
        }
    }

    @Test func anInvalidCatalogIsRejectedWithItsIssues() {
        #expect(throws: CatalogError.invalid([.emptyCourse("basics")])) {
            try SkillCatalog.decode(from: json(skills: "[]"))
        }
    }

    private func json(schemaVersion: Int = SkillCatalog.supportedSchemaVersion, skills: String) -> Data {
        let courses = #"[{"id": "basics", "title": {"en": "Basics"}}]"#
        return Data(
            #"{"schemaVersion": \#(schemaVersion), "libraryVersion": 1, "courses": \#(courses), "skills": \#(skills)}"#
                .utf8
        )
    }
}
