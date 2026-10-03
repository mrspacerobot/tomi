@testable import TomiCore

extension Course {
    static func fixture(_ id: CourseID, title: String = "A course") -> Course {
        Course(id: id, title: LocalizedText(["en": title]))
    }
}
