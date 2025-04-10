import Relux

extension AppsFlyer.Business {
    enum Action: Relux.Action {
        case setAppsFlyerLibStartState(_ state: Model.AppsFlyerStartState)
        
        case obtainStatusSuccess(status: Model.ATTStatus)
        case setAttPermissionRequestState(state: Model.ATTPermissionState)
        
        case obtainUIDSuccess(uid: String)
        
        case requestStatusSuccess(status: Model.ATTStatus)
    }
}
