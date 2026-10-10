import CryptoKit
import Foundation

/// The nonce of one Sign in with Apple request. Apple gets its SHA-256, Supabase the raw value,
/// so a stolen identity token cannot be replayed with another nonce.
nonisolated struct AppleNonce: Equatable, Sendable {
    let raw: String

    /// A fresh nonce: 32 random bytes from the system's secure generator, written as hex.
    static func random() -> AppleNonce {
        var generator = SystemRandomNumberGenerator()
        var bytes: [UInt8] = []
        for _ in 0..<32 {
            bytes.append(UInt8.random(in: UInt8.min...UInt8.max, using: &generator))
        }
        return AppleNonce(raw: hex(bytes))
    }

    /// What Apple is sent: the SHA-256 of the raw nonce, in lowercase hex.
    var sha256: String {
        Self.hex(Array(SHA256.hash(data: Data(raw.utf8))))
    }

    private static func hex(_ bytes: [UInt8]) -> String {
        bytes.map(twoDigitHex).joined()
    }

    private static func twoDigitHex(_ byte: UInt8) -> String {
        let digits = String(byte, radix: 16)
        if digits.count == 1 {
            return "0" + digits
        }
        return digits
    }
}
