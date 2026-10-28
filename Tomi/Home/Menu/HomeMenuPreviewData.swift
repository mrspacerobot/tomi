import Foundation
import TomiCore

/// Preview options are the fake server's menu, never invented in a view.
enum HomeMenuPreviewData {
    static let options = FakeServerData().options.courses
    static let menu: HomeMenuProgress? = HomeMenuProgress.make(options: options, skills: skills)

    /// The fake server's returning cook.
    static let skills = ShownProgress.previewReturning()?.snapshot?.skills
}
