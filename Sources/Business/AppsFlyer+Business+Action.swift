import Relux

extension AppsFlyer.Business {
    enum Action: Relux.Action {
        case obtainStatusInProgress
        case obtainStatusSuccess(status: Model.ATTStatus)
        case requestStatusSuccess(status: Model.ATTStatus)
    }
}
