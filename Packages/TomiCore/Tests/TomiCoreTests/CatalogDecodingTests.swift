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

    @Test func aCatalogSurvivesARoundTripThroughJSON() throws {
        let catalog = SkillCatalog.fixture()
        #expect(try SkillCatalog.decode(from: JSONEncoder().encode(catalog)) == catalog)
    }

    @Test func idsAreWrittenAsPlainStrings() throws {
        let json = try #require(String(bytes: JSONEncoder().encode(SkillCatalog.fixture()), encoding: .utf8))
        #expect(json.contains(#""id":"knife""#))
        #expect(json.contains(#""course":"basics""#))
    }

    @Test(arguments: [0, SkillCatalog.supportedSchemaVersion + 1])
    func anUnknownSchemaVersionIsRejectedBeforeReadingTheRest(version: Int) {
        #expect(throws: CatalogError.unsupportedSchemaVersion(version)) {
            try SkillCatalog.decode(from: json(schemaVersion: version, skills: #""a shape from the future""#))
        }
    }

    @Test(arguments: [#"{"libraryVersion": 1}"#, "not json", ""])
    func aFileWithoutASchemaVersionIsRejected(file: String) {
        #expect(throws: DecodingError.self) {
            try SkillCatalog.decode(from: Data(file.utf8))
        }
    }

    @Test func aSkillMissingAFieldIsRejected() {
        #expect(throws: DecodingError.self) {
            try SkillCatalog.decode(from: json(skills: #"[{"id": "knife", "course": "basics"}]"#))
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
