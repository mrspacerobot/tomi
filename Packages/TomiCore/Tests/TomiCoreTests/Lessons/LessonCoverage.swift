@testable import TomiCore

/// Which levels of which techniques still have no lesson that a cook on each diet could be served.
/// A lesson counts for a diet as written, with any one of its swaps, or with all of them.
struct LessonCoverage {
    /// The word for a cook who keeps no diet.
    static let noDiet = "any"

    let catalog: SkillCatalog
    let table: IngredientTable
    let lessons: [Lesson]

    /// One line per level that is not fully covered, in menu order: "skill level: diets with no lesson".
    func gapLines() throws -> [String] {
        var lines: [String] = []
        for skill in catalog.skills {
            lines += try gapLines(for: skill)
        }
        return lines
    }

    private func gapLines(for skill: Skill) throws -> [String] {
        var lines: [String] = []
        for level in skill.levels {
            let missing = try dietsWithoutLesson(skill: skill.id, level: level.number)
            if !missing.isEmpty {
                lines.append("\(skill.id.rawValue) \(level.number): " + missing.joined(separator: " "))
            }
        }
        return lines
    }

    private func dietsWithoutLesson(skill: SkillID, level: Int) throws -> [String] {
        let taught = lessons.filter { $0.skill == skill && $0.level == level }
        var missing: [String] = []
        if try !canServe(taught, diet: nil) {
            missing.append(Self.noDiet)
        }
        for diet in table.diets where try !canServe(taught, diet: diet.id) {
            missing.append(diet.id.rawValue)
        }
        return missing
    }

    private func canServe(_ taught: [Lesson], diet: DietID?) throws -> Bool {
        let cook = CookPreferences.fixture(diet: diet)
        for lesson in taught {
            for variant in try variants(of: lesson) where try variant.isAllowed(by: cook, in: table) {
                return true
            }
        }
        return false
    }

    /// The lesson as written, with each single swap, and with every swap at once.
    private func variants(of lesson: Lesson) throws -> [Lesson] {
        var variants = [lesson]
        for swap in lesson.swaps {
            variants.append(try lesson.applying(swap))
        }
        variants.append(try applyingEverySwap(to: lesson))
        return variants
    }

    /// Two swaps may offer different replacements for the same ingredient. The first one is taken.
    private func applyingEverySwap(to lesson: Lesson) throws -> Lesson {
        var swapped = lesson
        for swap in lesson.swaps {
            let isStillThere = swapped.ingredients.contains { $0.ingredient == swap.ingredient }
            if isStillThere {
                swapped = try swapped.applying(swap)
            }
        }
        return swapped
    }
}
