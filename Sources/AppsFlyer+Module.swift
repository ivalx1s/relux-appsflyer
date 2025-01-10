import Relux

extension AppsFlyer {
    @MainActor
    public final class Module: Relux.Module {
        public let states: [any Relux.State] = []
        public let uistates: [any Relux.Presentation.StatePresenting] = []
        public let sagas: [any Relux.Saga]
        public let routers: [any Relux.Navigation.RouterProtocol] = []

        public init(
        ) {
            let svc = AppsFlyer.Business.Service()
            let saga = AppsFlyer.Business.Saga(svc: svc)
            self.sagas = [saga]
        }
    }
}
