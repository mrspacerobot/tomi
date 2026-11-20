import Foundation

struct ShowTabItem<Tab: Hashable>: Identifiable {
    let id: Tab
    let title: LocalizedStringResource
    let icon: ShowTabIcon
}
