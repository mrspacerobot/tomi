/// Graph suggestions as `POST /v1/lessons/suggest` writes them. The recipe is soft scrambled eggs from the
/// cooking graph, kept as the graph writes it (snake_case step fields included), with a pan-sauce style swap.
enum GraphJSON {
    static let sourceRecipe =
        #"{"id": "recipe/soft-scrambled-eggs", "names": {"en": "Soft scrambled eggs"}, "tier": "drafted", "#
        + #""makes": "dish/soft-scrambled-eggs", "yields": {"unit": "serving", "value": 2}, "#
        + #""aliases": {"fr": ["Oeufs brouilles"]}, "equipment": ["equipment/saucepan", "equipment/whisk"], "#
        + #""ingredients": ["# + lines + #"], "steps": ["# + steps + #"]}"#

    private static let lines =
        #"{"thing": "ingredient/egg", "part": "egg", "forms": [], "amount": {"unit": "piece", "value": 5}}, "#
        + #"{"thing": "ingredient/butter", "part": "butter", "forms": [], "amount": {"unit": "gram", "value": 30}}, "#
        + #"{"thing": "ingredient/cream", "part": "enrichment", "forms": [], "#
        + #""amount": {"unit": "tablespoon", "value": 1}}, "#
        + #"{"thing": "ingredient/salt", "part": "salt", "forms": [], "amount": {"unit": "pinch", "value": 2}}"#

    private static let steps =
        #"{"text": "Whisk the eggs.", "technique": "technique/whisk", "temperature": null, "time": null, "#
        + #""with": [], "works_on": ["ingredient/egg"], "makes": [], "safety_points": [], "future": 1}, "#
        + #"{"text": "Stir over low heat.", "technique": "technique/scramble", "temperature": null, "#
        + #""time": {"from": 4, "to": 6, "unit": "minute"}, "with": [], "works_on": [], "makes": [], "#
        + #""safety_points": ["raw-or-lightly-cooked-egg"]}, "#
        + #"{"text": "Take it off the heat.", "technique": "technique/scramble", "temperature": null, "#
        + #""time": {"value": 30, "unit": "second"}, "with": [], "works_on": [], "makes": [], "safety_points": []}"#

    static let ratio = #""ratio": {"by": "volume", "original": 1.0, "stand_in": 1}"#
    static let caveat = #""caveat": "No butter aroma.""#

    static let plan =
        #"{"ingredients": [{"id": "ingredient/egg", "name": "Egg"}, {"id": "ingredient/oil", "name": "Oil"}], "#
        + #""substitutions": [{"removed": {"id": "ingredient/butter", "name": "Butter"}, "#
        + #""added": {"id": "ingredient/oil", "name": "Oil"}, "# + ratio + ", " + caveat + "}], "
        + #""omittedParts": ["enrichment"], "missing": [{"id": "ingredient/oil", "name": "Oil"}], "#
        + #""equipment": [{"id": "equipment/whisk", "name": "Whisk"}]}"#

    static let checked = #"{"diet": "vegan", "avoid": ["nuts"]}"#

    /// The recipe written for the cook: butter swapped for oil (amount scaled by the server), cream left out,
    /// and the steps counted again from one.
    static let recipe =
        #"{"yields": {"unit": "serving", "value": 2}, "ingredients": ["#
        + #"{"part": "egg", "id": "ingredient/egg", "name": "Egg", "amount": {"unit": "piece", "value": 5}, "#
        + #""forms": [{"id": "form/beaten", "name": "Beaten"}]}, "#
        + #"{"part": "butter", "id": "ingredient/oil", "name": "Oil", "#
        + #""amount": {"unit": "millilitre", "value": 30}, "forms": []}, "#
        + #"{"part": "salt", "id": "ingredient/salt", "name": "Salt", "amount": {"unit": "pinch", "value": 2}, "#
        + #""forms": []}], "steps": ["# + adaptedSteps + "]}"

    private static let adaptedSteps =
        #"{"number": 1, "text": "Whisk the eggs.", "time": null, "temperature": null, "safetyPoints": []}, "#
        + #"{"number": 2, "text": "Stir the eggs in the oil over low heat.", "#
        + #""time": {"from": 4, "to": 6, "unit": "minute"}, "temperature": {"value": 80, "unit": "celsius"}, "#
        + #""safetyPoints": ["raw-or-lightly-cooked-egg"]}, "#
        + #"{"number": 3, "text": "Take it off the heat.", "time": {"value": 30, "unit": "second"}, "#
        + #""temperature": null, "safetyPoints": []}"#

    static let swap =
        #"{"removed": {"id": "ingredient/butter", "name": "Butter"}, "#
        + #""added": {"id": "ingredient/oil", "name": "Oil"}, "# + ratio + ", " + caveat + "}"

    static let leftOut =
        #"{"part": "enrichment", "name": "Cream", "ingredients": [{"id": "ingredient/cream", "name": "Cream"}]}"#

    static let changes = #"{"swaps": ["# + swap + #"], "leftOut": ["# + leftOut + "]}"

    static func suggestion(
        plan: String = plan,
        checked: String = checked,
        recipe: String = recipe,
        changes: String = changes,
        extra: String = ""
    ) -> String {
        #"{"recipeId": "recipe/soft-scrambled-eggs", "title": "Soft scrambled eggs", "sourceRecipe": "#
            + sourceRecipe + #", "skill": {"id": "eggs", "name": "Eggs"}, "level": {"number": 1, "name": "Soft"}, "#
            + #""recipe": "# + recipe + #", "changes": "# + changes + #", "safePlan": "# + plan
            + #", "reason": "Quick tonight.", "checked": "# + checked + extra + "}"
    }

    static func response(special: String, alternatives: [String]) -> String {
        #"{"rankedBy": "model", "special": "#
            + special + #", "alternatives": ["# + alternatives.joined(separator: ", ") + "]}"
    }
}
