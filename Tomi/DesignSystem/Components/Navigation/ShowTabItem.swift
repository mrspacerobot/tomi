import Foundation

struct ShowTabItem<Tab: Hashable>: Identifiable {
    let id: Tab
    let title: LocalizedStringResource
    let icon: ShowTabIcon
    var identifier: String?

    var accessibilityID: String {
        if let identifier { return identifier }
        return String(describing: id)
    }
}
