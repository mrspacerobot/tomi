extension BackendLaunchOptions {
    var fakeAccount: String {
        if usesOtherAccount { return FakeAuthService.otherAccount }
        return FakeAuthService.account
    }
}
