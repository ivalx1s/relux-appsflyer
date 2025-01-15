import Relux

extension AppsFlyer {
    @MainActor
    public final class Module: Relux.Module {
        public let states: [any Relux.State]
        public let uistates: [any Relux.Presentation.StatePresenting]
        public let sagas: [any Relux.Saga]
        public let routers: [any Relux.Navigation.RouterProtocol] = []

        public init(
        ) {
            let svc = AppsFlyer.Business.Service()
            let saga = AppsFlyer.Business.Saga(svc: svc)
            self.sagas = [saga]

            let state = AppsFlyer.Business.State()
            self.states = [state]
            let viewState = AppsFlyer.UI.ViewState(state: state)
            self.uistates = [viewState]
        }
    }
}


// log
extension AppsFlyer {
    @_transparent
    static func log(_ message: String) {
        print(">>> Relux AppsFlyer \(#file) \(#function) \(#line) \(message)")
    }
}
