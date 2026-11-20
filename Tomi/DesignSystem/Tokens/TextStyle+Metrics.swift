nonisolated extension TextStyle {
    var metrics: TextMetrics {
        switch self {
        case .marqueeKicker: TextMetrics(typeface: .nunitoBlack, size: 15, lineHeight: 19)
        case .marquee: TextMetrics(typeface: .lilitaOne, size: 37, lineHeight: 40)
        case .showTitle: TextMetrics(typeface: .lilitaOne, size: 34, lineHeight: 39)
        case .showStat: TextMetrics(typeface: .lilitaOne, size: 43, lineHeight: 46)
        case .showButton: TextMetrics(typeface: .lilitaOne, size: 24, lineHeight: 27)
        case .answerKey: TextMetrics(typeface: .lilitaOne, size: 24, lineHeight: 27)
        case .cardTitle: TextMetrics(typeface: .lilitaOne, size: 21, lineHeight: 24)
        case .lowerThird: TextMetrics(typeface: .lilitaOne, size: 18, lineHeight: 22)
        case .showBodyStrong: TextMetrics(typeface: .nunitoExtraBold, size: 21, lineHeight: 27)
        case .showBody: TextMetrics(typeface: .nunitoExtraBold, size: 19, lineHeight: 25)
        case .showText: TextMetrics(typeface: .nunitoExtraBold, size: 18, lineHeight: 25)
        case .showLede: TextMetrics(typeface: .nunitoExtraBold, size: 18, lineHeight: 24)
        case .showNote: TextMetrics(typeface: .nunitoBold, size: 17, lineHeight: 22)
        case .showMeta: TextMetrics(typeface: .nunitoExtraBold, size: 16, lineHeight: 21)
        case .showLabel: TextMetrics(typeface: .nunitoBlack, size: 16, lineHeight: 20)
        case .showPill: TextMetrics(typeface: .nunitoBlack, size: 16, lineHeight: 20)
        case .showTag: TextMetrics(typeface: .nunitoBlack, size: 14, lineHeight: 18)
        case .showGlyph: TextMetrics(typeface: .nunitoBlack, size: 30, lineHeight: 34)
        }
    }
}
