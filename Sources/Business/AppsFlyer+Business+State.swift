import Relux
import Combine

extension AppsFlyer.Business {
    public final class State: Relux.HybridState, ObservableObject {
        @Published public private(set) var startState: Model.AppsFlyerStartState = .unknown
        @Published public private(set) var status: Model.ATTStatus?
        @Published public private(set) var attPermissionRequestState: Model.ATTPermissionState = .notAsked(.unknown)
        @Published public private(set) var appsFlyerUID: String?
        
        public init() {}
    }
}

extension AppsFlyer.Business.State {
    public func reduce(with action: any Relux.Action) async {
        switch action as? AppsFlyer.Business.Action {
            case .none: break
            case let .some(action): await _reduce(with: action)
        }
    }

    public func cleanup() async {
        self.status = .none
    }
}

extension AppsFlyer.Business.State {
    func _reduce(with action: AppsFlyer.Business.Action) async {
        switch action {
        case let .setAppsFlyerLibStartState(state):
            startState = state
        
        case
            let .obtainStatusSuccess(status),
            let .requestStatusSuccess(status):
            
            self.status = status
        case let .obtainUIDSuccess(uid):
            self.appsFlyerUID = uid
            
        case let .setAttPermissionRequestState(state):
            self.attPermissionRequestState = state
        }
    }
}
