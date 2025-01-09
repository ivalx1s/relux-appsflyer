import Relux

extension AppsFlyer.Business {
    public enum Effect: Relux.Effect {
        case setup(config: Model.Config)
        case identifyUser(id: Model.UserId?)
        case setUserData(data: Model.UserData)
        case track(event: Model.Event)
    }
}
