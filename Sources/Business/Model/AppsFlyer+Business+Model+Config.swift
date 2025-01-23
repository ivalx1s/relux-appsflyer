extension AppsFlyer.Business.Model {
    public struct Config {
        public let appId: String
        public let apiKey: String
        public let language: String
        public let debugEnabled: Bool

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
