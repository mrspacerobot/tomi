import Foundation
import Testing

@testable import Tomi

/// The account is read from the access token the session holds, so it is known without a connection.
@Suite struct AuthSessionAccountTests {
    func session(token: String) -> AuthSession {
        AuthSession(accessToken: token, refreshToken: "refresh", expiresAt: .october(27))
    }

    func token(claims: String) -> String {
        let payload = Data(claims.utf8).base64EncodedString()
            .replacing("+", with: "-").replacing("/", with: "_").replacing("=", with: "")
        return "header.\(payload).signature"
    }

    @Test func theAccountIsTheSubjectOfTheToken() {
        let signed = session(token: token(claims: #"{"sub": "9b2f-user", "role": "authenticated"}"#))
        #expect(signed.accountID == "9b2f-user")
    }

    @Test func aTokenThatCannotBeReadHasNoAccount() {
        #expect(session(token: "not-a-token").accountID == nil)
        #expect(session(token: token(claims: #"{"role": "authenticated"}"#)).accountID == nil)
        #expect(session(token: "a.!!!.c").accountID == nil)
    }
}
