import Foundation

extension AppsFlyer.Business.Model {
    public struct Event {
        public let name: String
        public let data: [String: Sendable]
        public let time: Date

        public init(
            name: String,
            data: [String: Sendable] = [:],
            time: Date = Date()
        ) {
            self.name = name
            self.data = data
            self.time = time
        }
    }
}

extension AppsFlyer.Business.Model.Event: Sendable {}
