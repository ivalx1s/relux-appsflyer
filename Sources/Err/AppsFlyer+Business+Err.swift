import Foundation

extension AppsFlyer.Business {
    public enum Err: Error {
        case failedToTrack(event: Model.Event, cause: Error)
        case failedToSetup(config: Model.Config, cause: Error)
        case failedToStart(cause: StartError)
    }
    
    public enum StartError: Error {
        case networkFailure(underlying: Error)
        
        /// May happen if device connection blocks trackers
        case badURL(underlying: Error)
        case timeout(underlying: Error)
        case unknown(underlying: Error)
    }
}
