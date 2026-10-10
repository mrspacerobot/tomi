import SwiftUI

/// What the photo showed that matched no ingredient. It cannot count, so it is listed in words only.
struct UnknownItems: View {
    let items: [ConfirmItem]

    var body: some View {
        ForEach(items) { item in
            Text(.confirmUnknown(item.label))
                .textStyle(.description)
        }
    }
}
