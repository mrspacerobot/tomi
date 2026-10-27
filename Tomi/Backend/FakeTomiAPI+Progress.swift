import TomiCore

/// The progress routes of the fake server. They answer from the chosen fixture and compute nothing.
extension FakeTomiAPI {
    func sendCookEntries(_ request: CookEntriesRequest) async throws -> CookEntriesResponse {
        try configuration.progressServer.answer(request)
    }

    func progress(_ calendar: CalendarContext) async throws -> ProgressResponse {
        try configuration.progressServer.progress()
    }
}
