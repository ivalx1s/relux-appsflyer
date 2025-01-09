import Relux

extension AppsFlyer.Business {
    public protocol ISaga: Relux.Saga {
        typealias Model = AppsFlyer.Business.Model
    }
}


extension AppsFlyer.Business {
    public actor Saga {
        private let svc: IService

        public init(
            svc: IService
        ) {
            self.svc = svc
        }
    }
}

extension AppsFlyer.Business.Saga: AppsFlyer.Business.ISaga {
    public func apply(_ effect: Relux.Effect) async {
        switch effect as? AppsFlyer.Business.Effect {
            case .none: break
            case let .setup(config): await setup(with: config)
            case let .identifyUser(id): await identifyUser(id: id)
            case let .setUserData(data): await setUserData(data: data)
            case let .track(event): await track(event: event)
      }
    }
}

extension AppsFlyer.Business.Saga {
    private func setup(with config: Model.Config) async {
        switch await svc.setup(with: config) {
            case .success: break
            case let .failure(err):  print("Apps flyer setup error: \(err)")
        }
    }

    private func identifyUser(id: Model.UserId?) async {
        await svc.identifyUser(id: id)
    }

    private func setUserData(data: Model.UserData) async {
        await svc.setUserData(data)
    }

    private func track(event: Model.Event) async {
        switch await svc.track(event: event) {
            case .success: break
            case let .failure(err): print("Apps flyer track event\(event) error: \(err)")
        }
    }
}
