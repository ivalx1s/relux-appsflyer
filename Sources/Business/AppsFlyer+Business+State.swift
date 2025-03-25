import Relux
import Combine

public extension AppsFlyer.Business {
    actor State: Relux.State {
        @Published public private(set) var status: Model.ATTStatus?
        
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
        case
            let .obtainStatusSuccess(status),
            let .requestStatusSuccess(status):
            self.status = status
        }
    }
}
