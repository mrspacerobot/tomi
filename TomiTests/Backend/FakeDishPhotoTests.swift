import Foundation
import Testing
import TomiCore

@testable import Tomi

/// With `--fake-dish-photos` the fake server names a dish photo, and the app loads it from the bundle, never the
/// network.
@MainActor
@Suite struct FakeDishPhotoTests {
    @Test func theArgumentTurnsPhotosOn() {
        let options = BackendLaunchOptions(arguments: ["--fake-backend", "--fake-dish-photos"])
        #expect(options.fakeServer.dishPhotos)
        #expect(!BackendLaunchOptions(arguments: ["--fake-backend"]).fakeServer.dishPhotos)
    }

    /// The photo shows the special's dish, so only the special names it.
    @Test func withPhotosTheSpecialAloneNamesTheFakePhoto() throws {
        let response = try FakeServerData().suggestions(for: CookProfile(), withPhotos: true)
        let special = try #require(response.special)
        #expect(special.photoURL?.host() == FakeDishPhoto.host)
        #expect(!response.alternatives.isEmpty)
        #expect(response.alternatives.allSatisfy { $0.photoURL == nil })
    }

    @Test func withoutPhotosNoSuggestionNamesOne() throws {
        let response = try FakeServerData().suggestions(for: CookProfile())
        #expect(response.special?.photoURL == nil)
        #expect(response.alternatives.allSatisfy { $0.photoURL == nil })
    }

    @Test func theFakeLoaderDecodesTheBundledPhoto() async throws {
        let url = try #require(URL(string: FakeDishPhoto.address))
        let photo = try #require(await DishPhotoLoader.fake.image(at: url))
        #expect(photo.width > 0)
    }

    @Test func aFakeLaunchLoadsDishPhotosFromTheBundle() throws {
        let options = BackendLaunchOptions(arguments: ["--fake-backend"])
        let services = try #require(AppServices.forLaunch(options, store: InMemoryProgressStore()))
        let classes = services.dishPhotos.session.configuration.protocolClasses ?? []
        #expect(classes.contains { $0 == FakeDishPhotoProtocol.self })
    }

    @Test func otherHostsAreLeftAlone() throws {
        let url = try #require(URL(string: "https://example.com/dish.webp"))
        #expect(!FakeDishPhotoProtocol.canInit(with: URLRequest(url: url)))
    }
}
