/// The check on what the kitchen must have for the dish.
extension Lesson {
    /// Equipment the list does not name is something no kitchen has, so the lesson would never be offered
    /// and nobody would be told. Sorted so reports are stable. A lesson may need no equipment at all.
    func equipmentIssues(list: EquipmentList) -> [LessonIssue] {
        let unknown = equipment.filter { !list.contains($0) }
        return unknown.sorted().map(LessonIssue.unknownEquipment)
    }
}
