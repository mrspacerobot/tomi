import TomiCore

/// One lesson as the fake server offers it: named in the cook's language, checked for the cook's own answers,
/// with every ingredient missing but the first, and the lesson's first listed swap applied.
nonisolated struct FakeOffer {
    let lesson: Lesson
    let options: LibraryOptions

    func offer(checkedFor profile: CookProfile) -> Offer {
        var offer = Offer(lessonID: lesson.id, revision: lesson.revision, title: LessonText.resolved(lesson.title))
        offer.minutes = lesson.minutes
        offer.skill = OfferSkill(id: lesson.skill, name: lesson.skill.rawValue)
        offer.level = NamedLevel(number: lesson.level, name: String(lesson.level))
        offer.swaps = swaps
        offer.ingredients = ingredients(of: dish(with: offer.swaps))
        offer.missing = Array(offer.ingredients.dropFirst())
        offer.reason = offer.title
        offer.checked = CheckedRestrictions(diet: profile.diet, avoid: profile.avoid)
        return offer
    }

    private var swaps: [OfferSwap] {
        guard let first = lesson.swaps.first else {
            return []
        }
        return [OfferSwap(removed: named(first.ingredient), added: named(first.replacement.ingredient))]
    }

    private func dish(with swaps: [OfferSwap]) -> Lesson {
        do {
            return try lesson.applying(listed: swaps.map(\.applied))
        } catch {
            return lesson
        }
    }

    private func ingredients(of dish: Lesson) -> [NamedOption] {
        dish.ingredients.map { named($0.ingredient) }
    }

    private func named(_ id: IngredientID) -> NamedOption {
        NamedOption(id: OptionID(rawValue: id.rawValue), name: FakeOptions.name(of: id.rawValue))
    }
}
