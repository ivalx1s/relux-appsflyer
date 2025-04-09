import Relux

extension AppsFlyer.Business {
    enum Action: Relux.Action {
        case obtainStatusSuccess(status: Model.ATTStatus)
        case setAttPermissionRequestState(state: Model.ATTPermissionState)
        
        case requestStatusSuccess(status: Model.ATTStatus)
    }
}
