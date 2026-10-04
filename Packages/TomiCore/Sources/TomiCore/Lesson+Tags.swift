/// Diet and avoid-list answers for a lesson. They come only from the ingredient table, and an ingredient
/// the table does not list throws `IngredientTableError.unknownIngredient`: unknown is never "suitable".
extension Lesson {
    /// Every fact of every ingredient of the dish.
    public func facts(in table: IngredientTable) throws -> Set<IngredientFactID> {
        var facts: Set<IngredientFactID> = []
        for line in ingredients {
            let ingredient = try table.ingredient(line.ingredient)
            facts.formUnion(ingredient.facts)
        }
        return facts
    }

    /// The diets the dish suits and the avoid items it triggers, worked out from the facts of every ingredient.
    public func tags(in table: IngredientTable) throws -> LessonTags {
        let facts = try facts(in: table)
        return LessonTags(
            facts: facts,
            suitableDiets: table.diets(allowing: facts),
            avoidItems: table.avoidItems(triggeredBy: facts)
        )
    }

    /// Whether this cook may be shown the lesson as written. Apply a swap first to ask about the swapped dish.
    /// The table decides, so a diet or avoid item it does not list refuses the lesson.
    public func isAllowed(by preferences: CookPreferences, in table: IngredientTable) throws -> Bool {
        let facts = try facts(in: table)
        return table.allows(facts, for: preferences)
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
