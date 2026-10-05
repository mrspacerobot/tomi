/// Why a speaker could not say a line. The cook never sees these, the next speaker in line takes over.
enum SpeakerError: Error, Equatable {
    case unavailable
    case invalidSettings
}
