import Foundation
import TomiCore

/// The option lists of the fake server. Names are test words, never shown to a real cook.
nonisolated struct FakeOptions {
    static let unknownThing = "a jar of something"

    let lessons: [Lesson]
    let catalog: SkillCatalog?

    var options: LibraryOptions {
        var options = LibraryOptions()
        options.libraryVersion = 1
        options.diets = [Self.described("fake-veg", "Vegetarian"), Self.described("fake-vegan", "Vegan")]
        options.avoidItems = [Self.named("fake-nuts", "Nuts"), Self.named("fake-dairy", "Dairy")]
        options.cuisines = names(of: lessons.map { $0.cuisine.rawValue })
        options.equipment = equipment
        options.experience = Experience.allCases.map { Self.described(OptionID(rawValue: $0.rawValue), $0.rawValue) }
        options.units = Units.allCases.map { Self.described(OptionID(rawValue: $0.rawValue), $0.rawValue) }
        options.ingredients = names(of: lessons.flatMap { $0.ingredients.map(\.ingredient.rawValue) })
        options.courses = FakeCourses(catalog: catalog).courses
        return options
    }

    private var equipment: [EquipmentOption] {
        names(of: lessons.flatMap { $0.equipment.map(\.rawValue) }).map { named in
            EquipmentOption(id: named.id, name: named.name, summary: named.name, assumed: true)
        }
    }

    /// Each id once, in the order first met, named after itself.
    private func names(of ids: [String]) -> [NamedOption] {
        var seen: [NamedOption] = []
        for id in ids where !seen.contains(where: { $0.id.rawValue == id }) {
            seen.append(NamedOption(id: OptionID(rawValue: id), name: Self.name(of: id)))
        }
        return seen
    }

    static func name(of id: String) -> String {
        id.replacing("-", with: " ").capitalized
    }

    private static func named(_ id: OptionID, _ name: String) -> NamedOption {
        NamedOption(id: id, name: name)
    }

    private static func described(_ id: OptionID, _ name: String) -> DescribedOption {
        DescribedOption(id: id, name: name.capitalized, summary: name)
    }
}
