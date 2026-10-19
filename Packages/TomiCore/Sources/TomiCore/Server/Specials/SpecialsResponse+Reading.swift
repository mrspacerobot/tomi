extension SpecialsResponse {
    /// The special and the alternatives that could be read. When the server sent offers and none could be read,
    /// that is an error: it must not look like a night with nothing to cook.
    static func readOffers(
        _ container: KeyedDecodingContainer<CodingKeys>
    ) throws -> (special: Offer?, alternatives: [Offer]) {
        let sentSpecial = try container.decodeIfPresent(LossyOffer.self, forKey: .special)
        let sentAlternatives = try container.decode([LossyOffer].self, forKey: .alternatives)
        let sent = (sentSpecial.map { [$0] } ?? []) + sentAlternatives
        let readable = sent.compactMap(\.offer)
        if !sent.isEmpty && readable.isEmpty {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "No offer.")
            throw DecodingError.dataCorrupted(context)
        }
        return (sentSpecial?.offer, sentAlternatives.compactMap(\.offer))
    }
}

/// An offer that may fail to read without failing the answer around it.
struct LossyOffer: Decodable {
    let offer: Offer?

    init(from decoder: any Decoder) throws {
        offer = try? Offer(from: decoder)
    }
}
