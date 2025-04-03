import Relux

extension AppsFlyer {
    public protocol IModule: Relux.Module {
        var appsFlyerIdProvider: AppsFlyer.Business.IAppsFlyerIdProvider { get async }
    }
}

extension AppsFlyer {
    @MainActor
    public final class Module: AppsFlyer.IModule {
        private let service: AppsFlyer.Business.IService
        public let states: [any Relux.AnyState]
        public let sagas: [any Relux.Saga]
        public var appsFlyerIdProvider: AppsFlyer.Business.IAppsFlyerIdProvider {
            get async { service }
        }

        public init(
        ) {
            let svc = AppsFlyer.Business.Service()
            self.service = svc
            let saga = AppsFlyer.Business.Saga(svc: svc)
            self.sagas = [saga]

            let state = AppsFlyer.Business.State()
            self.states = [state]
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
