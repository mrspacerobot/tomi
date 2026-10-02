/// The twelve techniques Tomi teaches, in menu order.
public enum SkillCatalog {
    public static let all: [Skill] = [
        Skill(id: .knife, course: .foundations),
        Skill(id: .eggs, course: .foundations),
        Skill(id: .boil, course: .foundations),
        Skill(id: .saute, course: .heatControl, prerequisites: [.knife]),
        Skill(id: .sear, course: .heatControl, prerequisites: [.knife]),
        Skill(id: .rice, course: .heatControl, prerequisites: [.boil]),
        Skill(id: .roast, course: .buildingFlavor, prerequisites: [.knife]),
        Skill(id: .pansauce, course: .buildingFlavor, prerequisites: [.sear]),
        Skill(id: .emulsion, course: .buildingFlavor, prerequisites: [.knife]),
        Skill(id: .pasta, course: .puttingItTogether, prerequisites: [.boil, .saute]),
        Skill(id: .braise, course: .puttingItTogether, prerequisites: [.sear, .roast]),
        Skill(id: .balance, course: .puttingItTogether, prerequisites: [.pansauce, .emulsion]),
    ]

    public static func skill(_ id: SkillID) -> Skill {
        guard let skill = all.first(where: { $0.id == id }) else {
            preconditionFailure("SkillCatalog is missing \(id)")
        }
        return skill
    }

    public static func skills(in course: Course) -> [Skill] {
        all.filter { $0.course == course }
    }
}
