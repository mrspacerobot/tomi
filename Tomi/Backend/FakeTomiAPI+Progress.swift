import TomiCore

/// The progress routes of the fake server. They answer from the chosen fixture and compute nothing.
extension FakeTomiAPI {
    func sendCookEntry(_ request: CookEntryRequest) async throws -> CookEntryResponse {
        try configuration.progressServer.answer(request)
    }

    func sendCookEntry(_ request: CookEntryRequest, for account: String) async throws -> CookEntryResponse {
        try configuration.progressServer.answer(request)
    }

    func progress(_ calendar: CalendarContext) async throws -> ProgressResponse {
        try configuration.progressServer.progress()
    }

    func progress(_ calendar: CalendarContext, for account: String) async throws -> ProgressResponse {
        try configuration.progressServer.progress()
    }
}
