import Foundation

/// Snapshot bodies as `GET /v1/progress` sends them, built from tomi-backend's example in `docs/progress.md`.
enum ProgressSnapshotBody {
    /// The backend's example, with the XP given and, when a test needs one, the moment the server computed it.
    static func example(xp: Int = 360, computedAt: String = "2026-10-26T18:43:02Z") -> Data {
        let withXP = exampleText.replacingOccurrences(of: #""xp": 360"#, with: #""xp": "# + String(xp))
        let moment = withXP.replacingOccurrences(of: "2026-10-26T18:43:02Z", with: computedAt)
        return Data(moment.utf8)
    }

    private static let exampleText = """
        {
          "schemaVersion": 1, "rulesVersion": 1, "catalogVersion": 1,
          "computedAt": "2026-10-26T18:43:02Z",
          "calendar": { "timeZone": "Europe/Amsterdam", "firstWeekday": 2 },
          "xp": 360,
          "rank": { "id": "commis", "name": "Commis", "tier": 1, "startsAt": 150, "nextAt": 400 },
          "streak": {
            "weeks": 2, "weeksBeforeThisWeek": 2, "daysThisWeek": 1, "goal": 3, "daysLeftInWeek": 4,
            "thisWeekMet": false, "atRisk": false, "lost": false,
            "weekStartsAt": "2026-10-25T23:00:00Z", "weekEndsAt": "2026-11-01T23:00:00Z"
          },
          "skills": [
            {
              "skill": "eggs", "status": "mastered", "missingPrerequisites": [], "currentLevel": 1,
              "levels": [
                { "number": 1, "cooks": 2, "cooksToComplete": 2, "open": true, "granted": false, "complete": true }
              ]
            }
          ],
          "masteredCount": 4, "focusSkill": "roux",
          "counted": { "finishedCooks": 6, "ignoredUnknownSkillOrLevel": 0 }
        }
        """

    /// A body of a layout this app does not read.
    static let unknownLayout = Data(#"{"schemaVersion": 2, "xp": 360}"#.utf8)
}
