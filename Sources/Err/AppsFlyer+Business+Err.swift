import Foundation

extension AppsFlyer.Business {
    public enum Err: Error {
        case failedToTrack(event: Model.Event, cause: Error)
        case failedToSetup(config: Model.Config, cause: Error)
    }
}
