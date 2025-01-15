import Relux
import Combine

extension AppsFlyer.Business {
    actor State: Relux.State {
        @Published var status: Model.ATTStatus?
    }
}

extension AppsFlyer.Business.State {
    func reduce(with action: any Relux.Action) async {
        switch action as? AppsFlyer.Business.Action {
            case .none: break
            case let .some(action): await _reduce(with: action)
        }
    }

    func cleanup() async {
        self.status = .none
    }
}
