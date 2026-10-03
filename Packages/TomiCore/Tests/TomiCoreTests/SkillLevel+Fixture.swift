@testable import TomiCore

extension SkillLevel {
    static func fixture(_ number: Int, name: String = "A level") -> SkillLevel {
        SkillLevel(number: number, name: LocalizedText(["en": name]))
    }
}
