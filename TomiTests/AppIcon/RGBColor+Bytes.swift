import TomiCore

extension RGBColor {
    /// Whether a rendered pixel shows this colour, allowing for rounding on the way to eight bits a channel.
    func isNear(_ bytes: [Int]) -> Bool {
        let channels = [red, green, blue].map { Int(($0 * 255).rounded()) }
        return zip(channels, bytes).allSatisfy { expected, rendered in
            abs(expected - rendered) <= 2
        }
    }
}
