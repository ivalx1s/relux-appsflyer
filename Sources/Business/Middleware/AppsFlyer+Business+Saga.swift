import Foundation
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
        case let .setup(config):
            await setup(with: config)
        case let .identifyUser(id):
            await identifyUser(id: id)
        case let .setUserData(data):
            await setUserData(data: data)
        case let .startCollectMetrics(delay):
            await startCollectMetrics(with: delay)
        case let .track(event):
            await track(event: event)
        case .obtainAppsFlyerUID:
            await obtainAppsFlyerUID()
        case .obtainATTStatus:
            await obtainATTStatus()
        case .requestATTPermission:
            await requestATTPermission()
        }
    }
}

extension AppsFlyer.Business.Saga {
    private func setup(with config: Model.Config) async {
        switch await svc.setup(with: config) {
        case .success: break
        case let .failure(err): print("Apps flyer setup error: \(err)")
        }
    }
    
    private func identifyUser(id: Model.UserId?) async {
        await svc.identifyUser(id: id)
    }
    
    private func setUserData(data: Model.UserData) async {
        await svc.setUserData(data)
    }
    
    private func startCollectMetrics(with delay: TimeInterval) async {
        let result = await svc.startCollectMetrics(with: delay)
        
        switch result {
        case .success:
            await action {
                AppsFlyer.Business.Action.setAppsFlyerLibStartState(.success)
            }
            
        case .failure(let error):
            print("AppsFlyer start error: \(error)")
            
            if case .failedToStart(let cause) = error {
                let setStartState: AppsFlyer.Business.Action = switch cause {
                case .badURL, .networkFailure:
                        .setAppsFlyerLibStartState(.networkFailure)
                case .timeout, .unknown:
                        .setAppsFlyerLibStartState(.libraryFailure)
                }
                
                await action {
                    setStartState
                }
            }
        }
    }
    
    private func track(event: Model.Event) async {
        await svc.track(event: event)
    }
    
    private func obtainAppsFlyerUID() async {
        let uid = await svc.appsFlyerUID
        await action {
            AppsFlyer.Business.Action.obtainUIDSuccess(uid: uid)
        }
    }
}

extension AppsFlyer.Business.Saga {
    private func obtainATTStatus() async {
        let status = await svc.getStatus()
        await action {
            AppsFlyer.Business.Action.obtainStatusSuccess(status: status)
        }
    }
    
    private func requestATTPermission() async {
        await action {
            AppsFlyer.Business.Action.setAttPermissionRequestState(state: .inProgress)
        }
        let status = await svc.requestStatus()
        await actions {
            AppsFlyer.Business.Action.requestStatusSuccess(status: status)
            AppsFlyer.Business.Action.setAttPermissionRequestState(state: .completed(status))
        }
    }
}
