import Foundation
import Observation
import SwiftUI
import TomiCore

/// Holds the email-auth form state and forwards each action to the auth service through the app flow.
@Observable
final class EmailAuthModel {
    let flow: AppFlowModel
    var email = ""
    var password = ""
    private(set) var mode = EmailAuthMode.signIn
    private(set) var notice: LocalizedStringResource?
    private(set) var isSubmitting = false

    init(flow: AppFlowModel) {
        self.flow = flow
    }

    var canSubmit: Bool {
        let emailIsPresent = !cleanEmail.isEmpty
        let passwordIsPresent = mode == .passwordRecovery || !password.isEmpty
        return emailIsPresent && passwordIsPresent && !isSubmitting
    }

    func choose(_ nextMode: EmailAuthMode) {
        mode = nextMode
        notice = nil
    }

    func submit() async {
        guard canSubmit else { return }
        notice = problemWithFields
        guard notice == nil else { return }
        isSubmitting = true
        defer { isSubmitting = false }
        await submitCurrentMode()
    }

    private var cleanEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var problemWithFields: LocalizedStringResource? {
        guard EmailCredential.isPlausibleAddress(cleanEmail) else {
            return .authInvalidEmail
        }
        let needsNewPassword = mode == .createAccount
        if needsNewPassword && !EmailCredential.isAcceptablePassword(password) {
            return .authPasswordTooShort(EmailCredential.minimumPasswordLength)
        }
        return nil
    }

    private func submitCurrentMode() async {
        switch mode {
        case .signIn: await signIn()
        case .createAccount: await createAccount()
        case .passwordRecovery: await sendPasswordReset()
        }
    }

    private func signIn() async {
        do {
            try await flow.signIn(email: cleanEmail, password: password)
        } catch {
            notice = .authSignInFailed
        }
    }

    private func createAccount() async {
        do {
            let result = try await flow.createAccount(email: cleanEmail, password: password)
            notice = message(for: result)
        } catch {
            notice = .authCreateFailed
        }
    }

    private func sendPasswordReset() async {
        do {
            try await flow.sendPasswordReset(to: cleanEmail)
            notice = .authRecoverySent
        } catch {
            notice = .authRecoveryFailed
        }
    }

    private func message(for result: SignUpResult) -> LocalizedStringResource {
        switch result {
        case .authenticated: .authAccountCreated
        case .emailConfirmationRequired: .authConfirmationRequired
        }
    }
}
