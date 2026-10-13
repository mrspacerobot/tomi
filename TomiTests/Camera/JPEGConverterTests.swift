import Foundation
import ImageIO
import Testing

@testable import Tomi

/// What leaves the phone with a fridge photo: always a small JPEG that fits the server, and the place and time it
/// was taken only when the cook agreed to let Tomi keep the photo.
@Suite struct JPEGConverterTests {
    @Test func aPhotoThatMayBeKeptKeepsItsPlaceAndTime() throws {
        let jpeg = try JPEGConverter.jpeg(from: TestPhoto.make(), keepingMetadata: true)
        let properties = TestPhoto.properties(of: jpeg)
        let place = properties[kCGImagePropertyGPSDictionary] as? [CFString: Any]
        let time = properties[kCGImagePropertyExifDictionary] as? [CFString: Any]
        #expect(place?[kCGImagePropertyGPSLatitude] as? Double == TestPhoto.latitude)
        #expect(time?[kCGImagePropertyExifDateTimeOriginal] as? String == TestPhoto.takenAt)
    }

    @Test func aPhotoThatMayOnlyBeReadLeavesWithoutThem() throws {
        let jpeg = try JPEGConverter.jpeg(from: TestPhoto.make(), keepingMetadata: false)
        let properties = TestPhoto.properties(of: jpeg)
        let time = properties[kCGImagePropertyExifDictionary] as? [CFString: Any]
        #expect(properties[kCGImagePropertyGPSDictionary] == nil)
        #expect(time?[kCGImagePropertyExifDateTimeOriginal] == nil)
    }

    @Test(arguments: [true, false])
    func aBigPhotoIsShrunkToTheLongestSideAndStaysSmall(keepingMetadata: Bool) throws {
        let big = TestPhoto.make(width: 3_000, height: 2_000)
        let jpeg = try JPEGConverter.jpeg(from: big, keepingMetadata: keepingMetadata)
        let properties = TestPhoto.properties(of: jpeg)
        #expect(Array(jpeg.prefix(2)) == [0xFF, 0xD8])
        #expect(jpeg.count < JPEGConverter.largestBytes)
        #expect(properties[kCGImagePropertyPixelWidth] as? Int == JPEGConverter.largestSide)
    }

    @Test(arguments: [true, false])
    func aTurnedPhotoIsTurnedOnceNotTwice(keepingMetadata: Bool) throws {
        let turned = TestPhoto.make(orientation: 6)
        let jpeg = try JPEGConverter.jpeg(from: turned, keepingMetadata: keepingMetadata)
        let properties = TestPhoto.properties(of: jpeg)
        #expect(properties[kCGImagePropertyPixelWidth] as? Int == 48)
        #expect(properties[kCGImagePropertyPixelHeight] as? Int == 64)
        let orientation = properties[kCGImagePropertyOrientation] as? Int
        #expect(orientation == nil || orientation == 1)
    }
}
