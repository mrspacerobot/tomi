import TomiCore

extension RGBColor {
    /// The colour seen when this one is laid over a ground and keeps only a share of its own strength.
    func laid(over ground: RGBColor, opacity: Double) -> RGBColor {
        RGBColor(
            red: red * opacity + ground.red * (1 - opacity),
            green: green * opacity + ground.green * (1 - opacity),
            blue: blue * opacity + ground.blue * (1 - opacity)
        )
    }
}
