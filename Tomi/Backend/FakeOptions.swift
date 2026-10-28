import Foundation
import TomiCore

/// What the fake server's option lists leave out on purpose. The lists themselves are the fixture
/// `fake-options.json`, with test words that are never shown to a real cook.
nonisolated enum FakeOptions {
    static let unknownThing = "a jar of something"
    /// An avoid id the fake lists do not name, as one saved by a newer server would be.
    static let unlistedSavedItem: OptionID = "fake-from-a-newer-server"
}
