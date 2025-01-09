import Relux

extension AppsFlyer {
    @MainActor
    public final class Module: Relux.Module {
        private let service: AppsFlyer.Business.IService

        public let states: [any Relux.State] = []
        public let uistates: [any Relux.Presentation.StatePresenting] = []
        public let sagas: [any Relux.Saga]
        public let routers: [any Relux.Navigation.RouterProtocol] = []

        public init(

        ) {
            let svc = AppsFlyer.Business.Service()
            self.service = svc
            let saga = AppsFlyer.Business.Saga(svc: svc)
            self.sagas = [saga]
        }
    }
}

