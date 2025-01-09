extension AppsFlyer.Business.Model {
    public struct Config {
        let appId: String
        let apiKey: String
        let language: String
        let debugEnabled: Bool

        public init(
            appId: String,
            apiKey: String,
            language: String,
            debugEnabled: Bool = false
        ) {
            self.appId = appId
            self.apiKey = apiKey
            self.language = language
            self.debugEnabled = debugEnabled
        }
    }
}

extension AppsFlyer.Business.Model.Config: Sendable {}
