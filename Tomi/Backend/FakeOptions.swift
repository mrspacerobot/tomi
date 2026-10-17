import Foundation
import TomiCore

/// The option lists of the fake server. Names are test words, never shown to a real cook.
nonisolated struct FakeOptions {
    static let unknownThing = "a jar of something"
    /// An avoid id the fake lists do not name, as one saved by a newer server would be.
    static let unlistedSavedItem: OptionID = "fake-from-a-newer-server"

    let lessons: [Lesson]
    let catalog: SkillCatalog?

    var options: LibraryOptions {
        var options = LibraryOptions()
        options.libraryVersion = 1
        options.diets = [Self.described("fake-veg", "Vegetarian"), Self.described("fake-vegan", "Vegan")]
        options.avoidItems = Self.avoidItems
        options.cuisines = names(of: lessons.map { $0.cuisine.rawValue })
        options.equipment = equipment
        options.experience = Experience.allCases.map { Self.described(OptionID(rawValue: $0.rawValue), $0.rawValue) }
        options.units = Units.allCases.map { Self.described(OptionID(rawValue: $0.rawValue), $0.rawValue) }
        options.staples = Self.staples
        options.ingredients =
            names(of: lessons.flatMap { $0.ingredients.map(\.ingredient.rawValue) }) + Self.cupboardIngredients
        options.courses = FakeCourses(catalog: catalog).courses
        return options
    }

    /// A few everyday staples, some assumed. The ids are test words, so no Swift file names a shipped id.
    static let staples = [
        StapleOption(id: "fake-salt", name: "Salt", assumed: true),
        StapleOption(id: "fake-oil", name: "Olive oil", assumed: true),
        StapleOption(id: "fake-pepper", name: "Pepper", assumed: true),
        StapleOption(id: "fake-rice", name: "Rice", assumed: false),
        StapleOption(id: "fake-pasta", name: "Pasta", assumed: false),
    ]

    /// Ingredients a cook may add to the cupboard by typing: every staple, and two spices that are not staples.
    static var cupboardIngredients: [NamedOption] {
        let spices = [
            NamedOption(id: "fake-cumin", name: "Cumin"), NamedOption(id: "fake-chilli", name: "Chilli flakes"),
        ]
        return staples.map { NamedOption(id: $0.id, name: $0.name) } + spices
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

    /// Mirrors the real list: allergens first, including ones the server derives, then the personal choices.
    private static let avoidItems = [
        AvoidOption(id: "fake-nuts", name: "Nuts", kind: .allergen),
        AvoidOption(id: "fake-dairy", name: "Dairy", kind: .allergen),
        AvoidOption(id: "fake-pork", name: "Pork", kind: .choice),
        AvoidOption(id: "fake-celery", name: "Celery", kind: .allergen),
        AvoidOption(id: "fake-alcohol", name: "Alcohol", kind: .choice),
    ]

    private static func named(_ id: OptionID, _ name: String) -> NamedOption {
        NamedOption(id: id, name: name)
    }

    private static func described(_ id: OptionID, _ name: String) -> DescribedOption {
        DescribedOption(id: id, name: name.capitalized, summary: name)
    }
}
