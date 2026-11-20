import SwiftUI

extension EnvironmentValues {
    /// Where the menu cards load dish photos from. `RootView` sets the launch's loader.
    @Entry var dishPhotos = DishPhotoLoader.live
}
