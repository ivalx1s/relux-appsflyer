import AppTrackingTransparency

public extension AppsFlyer.Business.Model {
    enum ATTStatus {
        case undefined
        case denied
        case restricted
        case authorized
        case unknown
    }
}

extension AppsFlyer.Business.Model.ATTStatus {
    static func from(_ status: ATTrackingManager.AuthorizationStatus) -> Self {
        status.asATTStatus
    }
}

extension AppsFlyer.Business.Model.ATTStatus: Sendable {}

extension ATTrackingManager.AuthorizationStatus {
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

