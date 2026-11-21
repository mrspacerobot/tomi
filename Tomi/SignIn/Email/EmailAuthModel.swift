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
    private(set) var needsConfirmation = false
    private(set) var noticeIsError = false
    private(set) var passwordFailed = false
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
        needsConfirmation = false
        noticeIsError = false
        passwordFailed = false
    }

    func submit() async {
        guard canSubmit else { return }
        passwordFailed = false
        notice = problemWithFields
        noticeIsError = notice != nil
        guard notice == nil else { return }
        isSubmitting = true
        defer { isSubmitting = false }
        await submitCurrentMode()
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
            noticeIsError = true
            passwordFailed = true
        }
    }

    private func createAccount() async {
        do {
            let result = try await flow.createAccount(email: cleanEmail, password: password)
            needsConfirmation = result == .emailConfirmationRequired
            if !needsConfirmation { notice = .authAccountCreated }
        } catch {
            notice = .authCreateFailed
            noticeIsError = true
        }
    }

    private func sendPasswordReset() async {
        do {
            try await flow.sendPasswordReset(to: cleanEmail)
            notice = .authRecoverySent
        } catch {
            notice = .authRecoveryFailed
            noticeIsError = true
        }
    }
}
