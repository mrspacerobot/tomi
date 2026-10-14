import Foundation
import ImageIO
import Testing

@testable import Tomi

/// What leaves the phone with a fridge photo: a small JPEG that fits the server, with the place and time it was
/// taken. Proof of concept: everything is kept.
@Suite struct JPEGConverterTests {
    @Test func aPhotoKeepsItsPlaceAndTime() throws {
        let jpeg = try JPEGConverter.jpeg(from: TestPhoto.make())
        let properties = TestPhoto.properties(of: jpeg)
        let place = properties[kCGImagePropertyGPSDictionary] as? [CFString: Any]
        let time = properties[kCGImagePropertyExifDictionary] as? [CFString: Any]
        #expect(place?[kCGImagePropertyGPSLatitude] as? Double == TestPhoto.latitude)
        #expect(time?[kCGImagePropertyExifDateTimeOriginal] as? String == TestPhoto.takenAt)
    }

    @Test func aBigPhotoIsShrunkToTheLongestSideAndStaysSmall() throws {
        let big = TestPhoto.make(width: 3_000, height: 2_000)
        let jpeg = try JPEGConverter.jpeg(from: big)
        let properties = TestPhoto.properties(of: jpeg)
        #expect(Array(jpeg.prefix(2)) == [0xFF, 0xD8])
        #expect(jpeg.count < JPEGConverter.largestBytes)
        #expect(properties[kCGImagePropertyPixelWidth] as? Int == JPEGConverter.largestSide)
    }

    @Test func aTurnedPhotoIsTurnedOnceNotTwice() throws {
        let turned = TestPhoto.make(orientation: 6)
        let jpeg = try JPEGConverter.jpeg(from: turned)
        let properties = TestPhoto.properties(of: jpeg)
        #expect(properties[kCGImagePropertyPixelWidth] as? Int == 48)
        #expect(properties[kCGImagePropertyPixelHeight] as? Int == 64)
        let orientation = properties[kCGImagePropertyOrientation] as? Int
        #expect(orientation == nil || orientation == 1)
    }
}
