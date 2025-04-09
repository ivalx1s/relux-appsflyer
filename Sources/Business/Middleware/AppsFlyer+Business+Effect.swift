import Relux
import Foundation

extension AppsFlyer.Business {
    public enum Effect: Relux.Effect {
        case setup(config: Model.Config)
        case identifyUser(id: Model.UserId?)
        case setUserData(data: Model.UserData)
        case startCollectMetrics(withDelay: TimeInterval = 0)
        case track(event: Model.Event)
        case obtainAppsFlyerUID
        case obtainATTStatus
        case requestATTPermission
    }
}
