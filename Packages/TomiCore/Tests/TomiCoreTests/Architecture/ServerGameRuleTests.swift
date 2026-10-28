import Testing

/// The server owns the game (`AGENTS.md`, Architecture). These fail if its rules come back into the rules package.
@Suite struct ServerGameRuleTests {
    @Test(arguments: [FolderRuleTests.sources, FolderRuleTests.tests])
    func theRulesPackageHasNoGameFolder(folder: String) throws {
        let folders = try Repository.folderNames(in: folder)
        #expect(!folders.isEmpty)
        #expect(!folders.contains(ServerGameRule.removedFolder))
    }

    @Test func theRulesPackageDeclaresNoRulesType() throws {
        let files = try Repository.swiftFiles(under: FolderRuleTests.sources)
        #expect(!files.isEmpty)
        #expect(ServerGameRule.violations(files) == [])
    }

    @Test func aRulesTypeIsCaughtWhateverItsKind() {
        let text = "public enum WeekRules {}\nstruct XPRules: Sendable {\nextension LevelRules {\n"
        let file = SourceFile(path: "Packages/TomiCore/Sources/TomiCore/Progress/Week.swift", text: text)
        let expected = ["WeekRules", "XPRules", "LevelRules"].map { "\(file.path) declares \($0)" }
        #expect(ServerGameRule.violations([file]) == expected)
    }

    @Test func otherTypesAndAMentionInACommentAreNotCaught() {
        let text = "/// struct OldRules was removed\npublic struct CookOutbox {\nlet rules = 1\n"
        let file = SourceFile(path: "Packages/TomiCore/Sources/TomiCore/Progress/CookOutbox.swift", text: text)
        #expect(ServerGameRule.violations([file]) == [])
    }
}
