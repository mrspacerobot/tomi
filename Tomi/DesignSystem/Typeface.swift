/// The cuts of the bundled families that the design uses. All are under the SIL Open Font License;
/// the files and their licence texts are in `Tomi/Resources/Fonts`, registered in `Config/Tomi-Info.plist`.
nonisolated enum Typeface: CaseIterable, Sendable {
    /// Gloock 400: titles, dish names, timer digits.
    case gloock
    /// Newsreader 400: explanations and answers.
    case newsreader
    /// Newsreader 500: step text.
    case newsreaderMedium
    /// Newsreader 400 italic: descriptions and hints.
    case newsreaderItalic
    /// Newsreader 600 italic: the key phrase of a step.
    case newsreaderSemiBoldItalic
    /// Figtree 500: the small line under a value.
    case figtreeMedium
    /// Figtree 600: buttons, chips, states.
    case figtreeSemiBold
    /// Figtree 700: labels.
    case figtreeBold

    case lilitaOne
    case nunitoBold
    case nunitoExtraBold
    case nunitoBlack

    /// The PostScript name the font file gives this cut. Newsreader, Figtree and Nunito are variable fonts, and these
    /// are their named instances; Newsreader picks its optical size from the point size by itself.
    var fontName: String {
        switch self {
        case .gloock: "Gloock-Regular"
        case .newsreader: "Newsreader16pt-Regular"
        case .newsreaderMedium: "NewsreaderRoman-Medium"
        case .newsreaderItalic: "Newsreader16pt-Italic"
        case .newsreaderSemiBoldItalic: "NewsreaderItalic-SemiBold"
        case .figtreeMedium: "Figtree-Medium"
        case .figtreeSemiBold: "Figtree-SemiBold"
        case .figtreeBold: "Figtree-Bold"
        case .lilitaOne: "LilitaOne"
        case .nunitoBold: "Nunito-Bold"
        case .nunitoExtraBold: "Nunito-ExtraBold"
        case .nunitoBlack: "Nunito-Black"
        }
    }
}
