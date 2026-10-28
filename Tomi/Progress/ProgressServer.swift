/// Where Home's progress comes from: the server and the sign-in, when this build has them. Without them the cook
/// sees the snapshot saved last and no server is asked.
struct ProgressServer {
    let api: (any TomiAPI)?
    let auth: (any AuthService)?

    init(api: (any TomiAPI)?, auth: (any AuthService)?) {
        self.api = api
        self.auth = auth
    }

    init(_ services: AppServices?) {
        api = services?.api
        auth = services?.auth
    }

    /// For previews: no server, and the fake cook signed in.
    static let preview = ProgressServer(api: nil, auth: FakeAuthService(signedIn: true))

    /// The id of the signed-in account, or nil when nobody is.
    var accountID: String? {
        auth?.accountID()
    }
}
