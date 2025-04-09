import AppTrackingTransparency

public extension AppsFlyer.Business.Model {
    /// Tracks the complete lifecycle of ATT permission requests
    enum ATTPermissionState {
        /// Tracking permission request hasn't been initiated yet
        case notAsked(ATTStatus)
        /// Permission request is currently being presented to the user
        case inProgress
        /// Permission request was completed with a specific ATTStatus result
        case completed(ATTStatus)
    }
    
    /// Simplified representation of App Tracking Transparency authorization status
    enum ATTStatus {
        /// User hasn't been asked for tracking permission yet
        case undefined
        /// User explicitly denied tracking permission
        case denied
        /// Tracking is restricted (parental controls, etc.)
        case restricted
        /// User granted tracking permission
        case authorized
        /// Unknown status (future iOS versions)
        case unknown
    }
}

// MARK: - Conversion Extensions

public extension AppsFlyer.Business.Model.ATTStatus {
    /// Converts Apple's native ATT status to our domain model
    static func from(_ status: ATTrackingManager.AuthorizationStatus) -> Self {
        status.asATTStatus
    }
    
    /// Returns true if status represents a determined state (not undefined/unknown)
    var isDetermined: Bool {
        switch self {
        case .undefined, .unknown: return false
        default: return true
        }
    }
}

public extension AppsFlyer.Business.Model.ATTPermissionState {
    /// Returns the current ATTStatus if in completed state
    var currentStatus: AppsFlyer.Business.Model.ATTStatus? {
        guard case let .completed(status) = self else { return nil }
        return status
    }
    
    /// Returns true if permission request is in progress
    var isInProgress: Bool {
        if case .inProgress = self { return true }
        return false
    }
}

extension ATTrackingManager.AuthorizationStatus {
    /// Maps Apple's native ATT status to our simplified domain model
    var asATTStatus: AppsFlyer.Business.Model.ATTStatus {
        switch self {
        case .notDetermined: return .undefined
        case .denied: return .denied
        case .restricted: return .restricted
        case .authorized: return .authorized
        @unknown default: return .unknown
        }
    }
}


// MARK: - Conformances

extension AppsFlyer.Business.Model.ATTStatus: Sendable, Hashable, Codable {}
extension AppsFlyer.Business.Model.ATTPermissionState: Sendable, Hashable, Codable {}


