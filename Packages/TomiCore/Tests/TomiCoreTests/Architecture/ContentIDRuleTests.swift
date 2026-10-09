import Testing

/// Content is data, not code: the ids of the library never appear in a Swift file of the app or the rules package.
@Suite struct ContentIDRuleTests {
    @Test func noSwiftFileNamesAnIDOfTheShippedLibrary() throws {
        let rule = ContentIDRule(ids: try ShippedContentIDs.all())
        let files = try Repository.swiftFiles(under: "Packages/TomiCore/Sources") + Repository.swiftFiles(under: "Tomi")
        #expect(rule.ids.count > 30)
        #expect(rule.violations(in: files) == [])
    }

    @Test func aSkillNamedInCodeIsCaught() {
        let file = SourceFile(path: "Tomi/Home/HomeView.swift", text: "if skill.id == \"sear\" { highlight() }\n")
        let rule = ContentIDRule(ids: ["sear", "roux"])
        #expect(rule.violations(in: [file]) == ["Tomi/Home/HomeView.swift names \"sear\""])
    }

    @Test func anIDInACommentOrAsPartOfALongerWordIsNotCaught() {
        let text = "// the \"sear\" skill comes first\nlet key = \"research\"\nlet sear = 1\n"
        let file = SourceFile(path: "Tomi/Home/HomeView.swift", text: text)
        #expect(ContentIDRule(ids: ["sear"]).violations(in: [file]) == [])
    }

    @Test func theShippedIDsCoverEveryKindOfContent() throws {
        let ids = try ShippedContentIDs.all()
        let oneOfEachKind: Set<String> = [
            "foundations", "sear", "butter", "olive-oil", "french", "stovetop", "spinach-hard-cheese-omelette",
        ]
        #expect(oneOfEachKind.isSubset(of: ids))
    }
}
