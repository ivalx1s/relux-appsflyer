extension AppsFlyer.Business.Model {
    public struct Config {
        let appId: String
        let apiKey: String
        let debugEnabled: Bool

        public init(
            appId: String,
            apiKey: String,
            debugEnabled: Bool = false
        ) {
            self.appId = appId
            self.apiKey = apiKey
            self.debugEnabled = debugEnabled
        }
    }
}

extension AppsFlyer.Business.Model.Config: Sendable {}
