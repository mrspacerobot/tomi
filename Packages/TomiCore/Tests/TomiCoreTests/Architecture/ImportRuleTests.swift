import Testing

/// The three layers of `AGENTS.md`: screens, services, and a rules package that knows nothing of Apple's UI,
/// data or AI frameworks.
@Suite struct ImportRuleTests {
    @Test func theRulesPackageImportsOnlyFoundation() throws {
        let files = try Repository.swiftFiles(under: "Packages/TomiCore/Sources")
        #expect(!files.isEmpty)
        #expect(ImportRule.violationsInRulesPackage(files) == [])
    }

    @Test func theAppTouchesServiceFrameworksOnlyInsideTheirServices() throws {
        let files = try Repository.swiftFiles(under: "Tomi")
        #expect(!files.isEmpty)
        #expect(ImportRule.violationsInApp(files) == [])
    }

    @Test func anImportOfSwiftUIInTheRulesPackageIsCaught() {
        let file = SourceFile(path: "Packages/TomiCore/Sources/TomiCore/Game/Rank.swift", text: "import SwiftUI\n")
        #expect(ImportRule.violationsInRulesPackage([file]) == ["\(file.path) imports SwiftUI"])
    }

    @Test func aScreenThatImportsAServiceFrameworkIsCaught() {
        let screen = SourceFile(path: "Tomi/Home/HomeView.swift", text: "import SwiftUI\nimport SwiftData\n")
        #expect(ImportRule.violationsInApp([screen]) == ["Tomi/Home/HomeView.swift imports SwiftData"])
    }

    @Test func aServiceMayImportItsOwnFramework() {
        let service = SourceFile(path: "Tomi/Persistence/ProgressStore.swift", text: "import SwiftData\n")
        #expect(ImportRule.violationsInApp([service]) == [])
    }

    @Test func anImportInACommentIsNotAnImport() {
        let file = SourceFile(path: "Tomi/Home/HomeView.swift", text: "// import SwiftData would break the rule\n")
        #expect(file.imports.isEmpty)
    }
}
