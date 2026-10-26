/// Decodes schema, graph identity and production review gates for teaching.
struct TeachingMetadata {
    let graphVersion: String
    let graphChannel: TeachingChannel
    var isProduction: Bool { graphChannel == .production }

    init(values: KeyedDecodingContainer<Teaching.CodingKeys>) throws {
        let version = try values.decode(Int.self, forKey: .schemaVersion)
        let language = try values.decode(String.self, forKey: .language)
        try Self.validateSchema(version, language, in: values)
        graphVersion = try values.decode(String.self, forKey: .graphVersion)
        graphChannel = try values.decode(TeachingChannel.self, forKey: .graphChannel)
        try Self.validateGraphVersion(graphVersion, in: values)
    }

    private static func validateGraphVersion(
        _ version: String,
        in values: KeyedDecodingContainer<Teaching.CodingKeys>
    ) throws {
        guard !version.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw DecodingError.dataCorruptedError(
                forKey: .graphVersion,
                in: values,
                debugDescription: "Missing graph version."
            )
        }
    }

    private static func validateSchema(
        _ version: Int,
        _ language: String,
        in values: KeyedDecodingContainer<Teaching.CodingKeys>
    ) throws {
        guard version == 1, language == "en" else {
            throw DecodingError.dataCorruptedError(
                forKey: .schemaVersion,
                in: values,
                debugDescription: "Unsupported teaching."
            )
        }
    }

    func validate(_ content: TeachingContent, in values: KeyedDecodingContainer<Teaching.CodingKeys>) throws {
        try validateTiers(content, in: values)
    }

    private func validateTiers(
        _ content: TeachingContent,
        in values: KeyedDecodingContainer<Teaching.CodingKeys>
    ) throws {
        guard !isProduction || content.isReviewed else {
            throw DecodingError.dataCorruptedError(
                forKey: .graphChannel,
                in: values,
                debugDescription: "Unreviewed production teaching."
            )
        }
    }
}
