import Relux

extension AppsFlyer {
    @MainActor
    public final class Module: Relux.Module {
        public let states: [any Relux.AnyState]
        public let sagas: [any Relux.Saga]

        public init(
        ) {
            let svc = AppsFlyer.Business.Service()
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
