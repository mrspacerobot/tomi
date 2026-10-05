#if DEBUG
    import Foundation

    /// How a debug build is told to open on the component gallery: `xcrun simctl launch <device>
    /// <bundle id> --component-gallery`, or the same launch argument from a UI test. Followed by
    /// `--gallery-section chips` the gallery opens scrolled to that section, for a screenshot of it.
    nonisolated enum GalleryLaunch {
        static let argument = "--component-gallery"
        static let sectionArgument = "--gallery-section"

        static var isRequested: Bool {
            ProcessInfo.processInfo.arguments.contains(argument)
        }

        /// The section named after `--gallery-section`, as the last part of its heading's key in the string
        /// catalog: `chips` for `gallery.section.chips`. Nil opens the gallery at its top.
        static var section: String? {
            section(in: ProcessInfo.processInfo.arguments)
        }

        static func section(in arguments: [String]) -> String? {
            guard let flag = arguments.firstIndex(of: sectionArgument) else {
                return nil
            }
            let name = arguments.index(after: flag)
            guard arguments.indices.contains(name) else {
                return nil
            }
            return "gallery.section.\(arguments[name])"
        }
    }
#endif
