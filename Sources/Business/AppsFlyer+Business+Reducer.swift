import Relux

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
