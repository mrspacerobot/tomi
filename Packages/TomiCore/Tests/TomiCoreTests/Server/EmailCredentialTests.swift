import Testing

@testable import TomiCore

@Suite struct EmailCredentialTests {
    @Test(arguments: ["cook@example.com", "a.b+c@mail.example.org"])
    func anAddressWithOneAtAndADottedDomainIsAccepted(address: String) {
        #expect(EmailCredential.isPlausibleAddress(address))
    }

    @Test(arguments: ["", "cook", "cook@", "@example.com", "cook@example", "co ok@example.com", "a@@b.com", "a@b."])
    func anythingElseIsRefused(address: String) {
        #expect(!EmailCredential.isPlausibleAddress(address))
    }

    @Test func aPasswordNeedsTheServersMinimumLength() {
        #expect(!EmailCredential.isAcceptablePassword("12345"))
        #expect(EmailCredential.isAcceptablePassword("123456"))
    }
}
