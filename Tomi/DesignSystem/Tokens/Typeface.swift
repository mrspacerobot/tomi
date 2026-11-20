/// The cuts of the bundled families that the design uses. All are under the SIL Open Font License;
/// the files and their licence texts are in `Tomi/Resources/Fonts`, registered in `Config/Tomi-Info.plist`.
nonisolated enum Typeface: CaseIterable, Sendable {
    case lilitaOne
    case nunitoBold
    case nunitoExtraBold
    case nunitoBlack

    /// The PostScript name of the cut. Nunito uses the variable font’s named instances.
    var fontName: String {
        switch self {
        case .lilitaOne: "LilitaOne"
        case .nunitoBold: "Nunito-Bold"
        case .nunitoExtraBold: "Nunito-ExtraBold"
        case .nunitoBlack: "Nunito-Black"
        }
    }
}
