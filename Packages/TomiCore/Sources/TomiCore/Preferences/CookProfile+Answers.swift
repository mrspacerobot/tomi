/// What a tap on an onboarding or settings question changes. The ids come from the server's lists;
/// nothing here knows what any of them means.
extension CookProfile {
    public func answer(for cuisine: OptionID) -> CuisineAnswer {
        if cuisinesNever.contains(cuisine) {
            return .never
        }
        if cuisinesLoved.contains(cuisine) {
            return .love
        }
        return .try
    }

    /// Puts the cuisine in exactly one of the three lists, so the server never sees it in two.
    public mutating func setAnswer(_ answer: CuisineAnswer, for cuisine: OptionID) {
        cuisinesLoved.remove(cuisine)
        cuisinesToTry.remove(cuisine)
        cuisinesNever.remove(cuisine)
        switch answer {
        case .love: cuisinesLoved.insert(cuisine)
        case .try: cuisinesToTry.insert(cuisine)
        case .never: cuisinesNever.insert(cuisine)
        }
    }

    public mutating func toggleAvoid(_ item: OptionID) {
        avoid.toggle(item)
    }

    public mutating func toggleCupboardStaple(_ ingredient: OptionID) {
        cupboardStaples.toggle(ingredient)
    }

    /// The kitchen as the question shows it: the cook's answer, or what the server assumes until they give one.
    public func kitchen(assumedUntilAnswered assumed: Set<OptionID>) -> Set<OptionID> {
        guard let equipment else {
            return assumed
        }
        return equipment
    }

    /// The first tap answers the kitchen question, starting from what the server assumed.
    public mutating func toggleEquipment(_ item: OptionID, assumedUntilAnswered assumed: Set<OptionID>) {
        var kitchen = kitchen(assumedUntilAnswered: assumed)
        kitchen.toggle(item)
        equipment = kitchen
    }
}
