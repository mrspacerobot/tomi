import Testing

/// The layout of saved data is safe for iCloud, and every stored field name is written down in the plan.
@Suite struct StoredRecordRuleTests {
    static let plan = "docs/implementation-plan.md"

    @Test func theAppStoresAProfileACookLogALessonInProgressAndTheLastSnapshot() throws {
        let records = StoredRecordRule.records(in: try Repository.swiftFiles(under: "Tomi/Persistence"))
        #expect(
            records.map(\.path) == [
                "Tomi/Persistence/ActiveLessonRecord.swift",
                "Tomi/Persistence/CookLogRecord.swift",
                "Tomi/Persistence/ProfileRecord.swift",
                "Tomi/Persistence/ProgressSnapshotRecord.swift",
            ]
        )
    }

    @Test func noRecordIsDeclaredOutsideThePersistenceFolder() throws {
        let all = StoredRecordRule.records(in: try Repository.swiftFiles(under: "Tomi"))
        #expect(all.allSatisfy { $0.path.hasPrefix("Tomi/Persistence/") })
    }

    @Test func everyStoredPropertyIsOptionalOrDefaultedAndNothingIsUnique() throws {
        let files = try Repository.swiftFiles(under: "Tomi/Persistence")
        #expect(StoredRecordRule.violations(in: files) == [])
    }

    @Test func everyStoredFieldIsListedInThePlan() throws {
        let files = try Repository.swiftFiles(under: "Tomi/Persistence")
        let fieldCount = StoredRecordRule.records(in: files).flatMap { StoredRecordRule.fieldNames(of: $0) }.count
        #expect(fieldCount >= 36)
        #expect(StoredRecordRule.fields(of: files, missingFrom: try Repository.text(Self.plan)) == [])
    }

    @Test func aStoredPropertyThatIsNotOptionalIsCaught() {
        let record = Self.record(properties: "    var diet: String?\n    var servings: Int\n")
        #expect(
            StoredRecordRule.violations(in: [record]) == [
                "Tomi/Persistence/Record.swift stores \"var servings: Int\", which is neither optional nor defaulted"
            ]
        )
    }

    @Test func aDefaultedPropertyIsAllowed() {
        let record = Self.record(properties: "    var servings: Int = 2\n")
        #expect(StoredRecordRule.violations(in: [record]) == [])
    }

    @Test(arguments: ["    @Attribute(.unique) var stableID: UUID?\n", "    #Unique<Record>([\\.stableID])\n"])
    func aUniqueConstraintIsCaught(declaration: String) {
        let record = Self.record(properties: declaration)
        #expect(StoredRecordRule.violations(in: [record]).count == 1)
    }

    @Test func aStoredFieldThePlanDoesNotListIsCaught() {
        let record = Self.record(properties: "    var diet: String?\n    var shoeSize: Int?\n")
        #expect(StoredRecordRule.fields(of: [record], missingFrom: "Stored fields: `diet`.") == ["shoeSize"])
    }

    @Test func aFileWithoutAModelIsNotARecord() {
        let view = SourceFile(path: "Tomi/Home/HomeView.swift", text: "struct HomeView {\n    var count: Int\n}\n")
        #expect(StoredRecordRule.violations(in: [view]) == [])
    }

    private static func record(properties: String) -> SourceFile {
        let text = "import SwiftData\n\n@Model\nfinal class Record {\n" + properties + "}\n"
        return SourceFile(path: "Tomi/Persistence/Record.swift", text: text)
    }
}
