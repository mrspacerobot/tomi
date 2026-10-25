import Foundation

extension Bundle {
    /// A throwaway bundle whose Info.plist holds these values, as the build settings would write them.
    static func fixture(info: [String: String]) throws -> Bundle {
        let plist = try PropertyListSerialization.data(fromPropertyList: info, format: .xml, options: 0)
        return try fixture(files: ["Info.plist": plist])
    }
}
