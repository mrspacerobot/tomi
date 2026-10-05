import Foundation
import SwiftUI
import TomiCore

/// Everything a launch puts together before the first screen: the library, the store and the saved progress.
/// The launch arguments choose the store, so UI tests never touch the cook's own.
struct AppLaunch {
    let catalog: SkillCatalog?
    let progress: SavedProgressModel
    let ingredientTable: IngredientTable?
    /// Nil follows the phone. Only a test sets it.
    let colorScheme: ColorScheme?
    /// Nil when saved data cannot be read: no answer may then be asked for or saved.
    let onboarding: OnboardingModel?

    init(arguments: [String], now: Date) {
        let catalog = BundledLibrary.catalog()
        let options = StoreLaunchOptions(arguments: arguments)
        let store = ProgressStoreOpener.store(for: options, catalog: catalog)
        let reader = ProgressSummaryReader(store: store, catalog: catalog, calendar: .current)
        self.catalog = catalog
        self.progress = SavedProgressModel(reader: reader, now: now)
        self.colorScheme = AppearanceLaunchOption.colorScheme(in: arguments)
        self.ingredientTable = BundledLibrary.ingredientTable()
        self.onboarding = try? OnboardingModel(store: store, now: Date.init)
    }
}
