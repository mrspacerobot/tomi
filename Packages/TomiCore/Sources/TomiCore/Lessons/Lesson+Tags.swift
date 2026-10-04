/// Diet and avoid-list answers for a lesson. They come only from the ingredient table, and an ingredient
/// the table does not list throws `IngredientTableError.unknownIngredient`: unknown is never "suitable".
extension Lesson {
    /// The diets the dish suits and the avoid items it triggers, added up over every ingredient.
    public func tags(in table: IngredientTable) throws -> LessonTags {
        var diets = Set(Diet.allCases)
        var avoidItems: Set<AvoidItem> = []
        for line in ingredients {
            let ingredient = try table.ingredient(line.ingredient)
            diets.formIntersection(ingredient.allowingDiets)
            avoidItems.formUnion(ingredient.avoidItems)
        }
        return LessonTags(suitableDiets: diets, avoidItems: avoidItems)
    }

    /// Whether this cook may be shown the lesson as written. Apply a swap first to ask about the swapped dish.
    public func isAllowed(by preferences: CookPreferences, in table: IngredientTable) throws -> Bool {
        try tags(in: table).allow(preferences)
    }

    /// The lesson with one ingredient replaced. Its tags are then worked out from the new ingredient list,
    /// so a swap changes who may eat the dish without anyone writing that down.
    /// The words of the steps are not changed here.
    public func applying(_ swap: LessonSwap) throws -> Lesson {
        guard let position = ingredients.firstIndex(where: { $0.ingredient == swap.ingredient }) else {
            throw LessonError.swapOfIngredientNotInLesson(swap.ingredient)
        }
        var swapped = self
        swapped.ingredients[position] = swap.replacement
        return swapped
    }
}
