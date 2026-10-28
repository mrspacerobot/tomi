import Foundation

extension CookEntry {
    /// The zone the cook was made in. A cook saved before zones were recorded has none, and is sent with the zone
    /// of the calendar the upload passes in, the best that is known about it.
    func zone(orElse fallback: TimeZone) -> TimeZone {
        guard let zone = session.timeZone else {
            return fallback
        }
        return zone
    }
}
